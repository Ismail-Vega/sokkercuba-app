import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences_android/shared_preferences_android.dart';
import 'package:shared_preferences_foundation/shared_preferences_foundation.dart';

import '../constants/constants.dart';
import '../main.dart';
import 'browser/browser_api_result.dart';
import 'browser/browser_session.dart';
import 'browser/sokker_endpoints.dart';

/// What a native probe of `/api/current` found.
enum NativeSessionStatus {
  /// Dio reached the API with a valid session.
  authenticated,

  /// Dio reached the API and Sokker rejected the session.
  unauthenticated,

  /// Cloudflare answered instead of Sokker.
  cloudflareBlocked,

  /// The request never completed.
  networkError,
}

class NativeSessionProbe {
  const NativeSessionProbe(this.status, {this.user});

  final NativeSessionStatus status;
  final Map<String, dynamic>? user;
}

/// Sokker API access.
///
/// Two transports sit behind the same methods:
///
///  * **native Dio** with [PersistCookieJar] — the original path, used whenever
///    it works;
///  * **browser-backed** — used only when a [BrowserSession] has been confirmed
///    authenticated *and* the endpoint is on the allowlist in
///    `sokker_endpoints.dart`.
///
/// Callers are unchanged: they still get decoded JSON or `null`.
class ApiClient {
  ApiClient()
      : _dio = Dio(BaseOptions(
          baseUrl: sokkerOrigin,
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          validateStatus: (status) => status != null && status < 600,
        ));

  final Dio _dio;
  late PersistCookieJar _cookieJar;

  late final Future<void> _ready = _init();

  Future<void> _init() async {
    if (Platform.isAndroid) SharedPreferencesAndroid.registerWith();
    if (Platform.isIOS) SharedPreferencesFoundation.registerWith();

    final appDocDir = await getApplicationDocumentsDirectory();
    final cookiePath = '${appDocDir.path}/.cookies';

    _cookieJar = PersistCookieJar(storage: FileStorage(cookiePath));
  }

  /// Kept for existing call sites; initialisation happens once per instance.
  Future<void> initCookieJar() => _ready;

  /// Clears the native cookie jar. The browser session is cleared separately
  /// through [BrowserSession.signOut].
  Future<void> clearSession() async {
    await _ready;
    await _cookieJar.deleteAll();
  }

  /// Detects a Cloudflare interstitial without materialising the whole body.
  bool isCloudflareChallenge(Response<dynamic> response) {
    if (response.headers.value('cf-mitigated') == 'challenge') return true;

    final status = response.statusCode;
    if (status != 403 && status != 503 && status != 429) return false;

    final data = response.data;
    if (data is! String) return false;

    // Cloudflare puts its markers in the document head.
    final head = data.length > 4096 ? data.substring(0, 4096) : data;
    return head.contains('Just a moment') ||
        head.contains('challenges.cloudflare.com') ||
        head.contains('cf-browser-verification');
  }

  /// Classifies the native session without touching navigation or app state.
  ///
  /// Used at startup so a Cloudflare block cannot be mistaken for a sign-out.
  Future<NativeSessionProbe> probeNativeSession() async {
    await _ready;
    try {
      final response = await _dio.get(
        userUrl,
        options: Options(headers: {'Cookie': await _cookieHeader()}),
      );

      if (isCloudflareChallenge(response)) {
        _log('native probe: cloudflare challenge');
        return const NativeSessionProbe(NativeSessionStatus.cloudflareBlocked);
      }
      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        _log('native probe: authenticated');
        return NativeSessionProbe(
          NativeSessionStatus.authenticated,
          user: response.data as Map<String, dynamic>,
        );
      }
      if (response.statusCode == 401 || response.statusCode == 403) {
        _log('native probe: unauthenticated (${response.statusCode})');
        return const NativeSessionProbe(NativeSessionStatus.unauthenticated);
      }
      _log('native probe: unexpected status ${response.statusCode}');
      return const NativeSessionProbe(NativeSessionStatus.networkError);
    } catch (error) {
      _log('native probe failed: ${error.runtimeType}');
      return const NativeSessionProbe(NativeSessionStatus.networkError);
    }
  }

  Future<String> _cookieHeader() async {
    final cookies = await _cookieJar.loadForRequest(Uri.parse('$sokkerOrigin/api'));
    return cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');
  }

  /// POSTs to Sokker natively.
  ///
  /// This stays on Dio on purpose. The only POST the app makes to the API is
  /// `/api/auth/login`, and credentials are never handed to the WebView; the
  /// remaining POSTs are legacy form endpoints, not JSON APIs.
  Future<Response<dynamic>?> sendData(String endpoint, dynamic data,
      {Map<String, String>? headers}) async {
    await _ready;
    try {
      final isLogin = endpoint == loginUrl;

      final options = Options(
        headers: {'Cookie': await _cookieHeader(), ...?headers},
      );

      _log('POST $endpoint');

      final response = await _dio.post(endpoint,
          data: data, options: isLogin ? null : options);

      _log('POST $endpoint -> ${response.statusCode} '
          'cf=${isCloudflareChallenge(response)}');

      final setCookies = response.headers.map['set-cookie'];

      if (setCookies != null && isLogin) {
        await _cookieJar.saveFromResponse(Uri.parse('$sokkerOrigin/api'),
            setCookies.map((str) => Cookie.fromSetCookieValue(str)).toList());
      }
      return response;
    } catch (error) {
      _log('POST $endpoint failed: ${error.runtimeType}');
      return null;
    }
  }

  /// GETs JSON from Sokker, through whichever transport is usable.
  Future<dynamic> fetchData(String endpoint,
      {Map<String, String>? headers,
      Map<String, dynamic>? queryParameters}) async {
    final session = BrowserSession.instance;
    if (session.isReady &&
        isAllowedEndpoint(endpoint, queryParameters: queryParameters)) {
      return _fetchThroughBrowser(endpoint, queryParameters, session);
    }

    await _ready;

    try {
      final options = Options(
        headers: {
          'Cookie': await _cookieHeader(),
          if (headers != null) ...headers,
        },
      );

      final response = await _dio.get(endpoint,
          options: options, queryParameters: queryParameters);
      return await _handleResponse(endpoint, response);
    } catch (error) {
      _log('GET $endpoint failed: ${error.runtimeType}');
      return null;
    }
  }

  Future<dynamic> _fetchThroughBrowser(
    String endpoint,
    Map<String, dynamic>? queryParameters,
    BrowserSession session,
  ) async {
    final result =
        await session.request(endpoint, queryParameters: queryParameters);

    if (result.isSuccess) return result.decodedData;

    // The session raises its own sign-in surface for a stale or challenged
    // session, so there is nothing to navigate to here.
    if (result.errorCategory == BrowserErrorCategory.unsupportedEndpoint) {
      _log('browser transport refused $endpoint; nothing fetched');
    }
    return null;
  }

  Future<dynamic> _handleResponse(String endpoint, Response response) async {
    if (response.statusCode == 200) {
      return response.data;
    }

    if (isCloudflareChallenge(response)) {
      _log('GET $endpoint -> cloudflare challenge');
      return null;
    }

    if (response.statusCode == 401) {
      _log('GET $endpoint -> 401, returning to login');
      navigatorKey.currentState
          ?.pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
      return null;
    }

    _log('GET $endpoint -> ${response.statusCode}');
    return null;
  }

  void _log(String message) {
    if (kDebugMode) debugPrint('[api] $message');
  }
}
