import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences_android/shared_preferences_android.dart';
import 'package:shared_preferences_foundation/shared_preferences_foundation.dart';

import '../main.dart';

class ApiClient {
  late Dio _dio;
  late PersistCookieJar _cookieJar;
  bool _isInitialized = false;

  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: 'https://sokker.org',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ));
    _init();
  }

  Future<void> _init() async {
    await initCookieJar();
    _isInitialized = true;
  }

  Future<void> initCookieJar() async {
    if (Platform.isAndroid) SharedPreferencesAndroid.registerWith();
    if (Platform.isIOS) SharedPreferencesFoundation.registerWith();

    final appDocDir = await getApplicationDocumentsDirectory();
    final cookiePath = '${appDocDir.path}/.cookies';

    _cookieJar = PersistCookieJar(storage: FileStorage(cookiePath));
  }

  Future<void> _ensureInitialized() async {
    while (!_isInitialized) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  Future<dynamic> sendData(String endpoint, dynamic data,
      {Map<String, String>? headers}) async {
    await _ensureInitialized();
    try {
      final cookies =
          await _cookieJar.loadForRequest(Uri.parse('https://sokker.org/api'));

      String cookiesString =
          cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      final options = Options(
        headers: {'Cookie': cookiesString, ...?headers},
      );

      final isLogin = endpoint == '/api/auth/login';

      final response = await _dio.post(endpoint,
          data: data, options: isLogin ? null : options);

      final setCookies = response.headers.map['set-cookie'];

      if (setCookies != null && isLogin) {
        await _cookieJar.saveFromResponse(Uri.parse('https://sokker.org/api'),
            setCookies.map((str) => Cookie.fromSetCookieValue(str)).toList());
      }
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Exception while sending data: $e');
      }
      return null;
    }
  }

  Future<dynamic> fetchData(String endpoint,
      {Map<String, String>? headers,
      Map<String, dynamic>? queryParameters}) async {
    await _ensureInitialized();

    try {
      final cookies =
          await _cookieJar.loadForRequest(Uri.parse('https://sokker.org/api'));

      String cookiesString =
          cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      final options = Options(
        headers: {
          'Cookie': cookiesString,
          if (headers != null) ...headers,
        },
      );

      final response = await _dio.get(endpoint,
          options: options, queryParameters: queryParameters);
      return _handleResponse(response);
    } catch (e) {
      if (kDebugMode) {
        print('Exception while fetching data: $e');
      }
      return null;
    }
  }

  Future<dynamic> _handleResponse(Response response) async {
    if (response.statusCode == 200) {
      return response.data;
    } else if (response.statusCode == 401) {
      navigatorKey.currentState
          ?.pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
      return null;
    } else {
      if (kDebugMode) {
        print('Failed to handle response. Status code: ${response.statusCode}');
      }
      return null;
    }
  }
}
