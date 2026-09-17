import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../constants/constants.dart';
import 'browser_api_result.dart';
import 'sokker_endpoints.dart';

/// Lifecycle of the browser-backed Sokker session.
enum BrowserSessionState {
  /// No WebView session exists.
  idle,

  /// A page is loading and nothing has been classified yet.
  loading,

  /// Cloudflare is showing a human-verification challenge.
  challenge,

  /// Cloudflare is satisfied but Sokker does not recognise the session.
  needsLogin,

  /// `/api/current` returned authenticated JSON inside the WebView.
  ready,

  /// The WebView itself could not be used.
  failed,
}

/// Owns the one authenticated Sokker browser session and executes allowlisted
/// same-origin API requests inside it.
///
/// The WebView keeps the protected session: its cookies (including
/// `cf_clearance`) never leave the web view, and no cookie, token or raw HTML
/// ever crosses back into Dart. Dart hands the bridge an allowlisted
/// `path?query`; the bridge hands back a status, a classification and — only
/// for JSON responses — the decoded payload.
class BrowserSession extends ChangeNotifier {
  BrowserSession._();

  static final BrowserSession instance = BrowserSession._();

  /// JavaScript channel name. Must be a valid JS identifier.
  static const String _channelName = 'SokkerBridge';
  static const String _homeUrl = '$sokkerOrigin/';
  static const Duration _requestTimeout = Duration(seconds: 30);
  static const Duration _probeCooldown = Duration(seconds: 3);
  static const Duration _probeDelay = Duration(milliseconds: 800);
  static const int _maxConcurrentRequests = 6;

  WebViewController? _controller;
  BrowserSessionState _state = BrowserSessionState.idle;
  bool _visible = false;
  bool _pageLoading = false;
  String? _accountName;
  String? _failureMessage;

  final Map<String, Completer<BrowserApiResult>> _pending =
      <String, Completer<BrowserApiResult>>{};
  final Queue<Completer<void>> _waiting = Queue<Completer<void>>();
  int _inFlight = 0;
  int _nextRequestId = 0;

  Completer<bool>? _gate;
  Future<BrowserApiResult>? _probeFuture;
  DateTime? _lastProbeAt;
  Timer? _probeTimer;

  /// The live controller, or `null` when no session exists. Only the
  /// `BrowserSessionHost` should render it.
  WebViewController? get controller => _controller;

  BrowserSessionState get state => _state;

  /// True once `/api/current` has been confirmed inside this WebView.
  bool get isReady =>
      _state == BrowserSessionState.ready && _controller != null;

  /// Whether the sign-in surface should cover the app.
  bool get isVisible => _visible && _controller != null;

  bool get isPageLoading => _pageLoading;

  /// Sokker account name reported by `/api/current`, for display only.
  String? get accountName => _accountName;

  String? get failureMessage => _failureMessage;

  /// Whether this platform has a WebView implementation at all.
  static bool get isSupportedPlatform => Platform.isIOS || Platform.isAndroid;

  // ---------------------------------------------------------------------
  // Session lifecycle
  // ---------------------------------------------------------------------

  /// Brings up the browser session and resolves when the user has either
  /// finished (`true`) or abandoned it (`false`).
  ///
  /// Resolves immediately when a ready session already exists.
  Future<bool> ensureReady() {
    if (isReady) return Future<bool>.value(true);

    if (!isSupportedPlatform) {
      _failureMessage =
          'The in-app browser session is only available on iOS and Android.';
      _setState(BrowserSessionState.failed);
      return Future<bool>.value(false);
    }

    final gate = _gate ??= Completer<bool>();

    if (_controller == null) {
      try {
        _controller = _createController();
      } catch (error) {
        _log('controller creation failed: ${error.runtimeType}');
        _failureMessage = 'The in-app browser could not be started.';
        _setState(BrowserSessionState.failed);
        _completeGate(false);
        return gate.future;
      }
      _failureMessage = null;
      _setState(BrowserSessionState.loading, notify: false);
      unawaited(_loadHome());
    }

    _visible = true;
    notifyListeners();
    return gate.future;
  }

  /// Shows the sign-in surface without creating a gate (used when an in-app
  /// request discovers the session went stale).
  void show() {
    if (_controller == null || _visible) return;
    _visible = true;
    notifyListeners();
  }

  /// Hides the surface; the session and its WebView stay alive.
  void hide() {
    if (!_visible) return;
    _visible = false;
    notifyListeners();
  }

  /// The user finished: hide the surface and release `ensureReady`.
  void completeSession() {
    _visible = false;
    _completeGate(true);
    notifyListeners();
  }

  /// The user cancelled. The session is abandoned and the controller dropped;
  /// Cloudflare clearance survives in the shared cookie store, so retrying is
  /// cheap.
  void abandon() {
    _log('session abandoned by user');
    _teardown(BrowserErrorCategory.webViewFailure);
    _setState(BrowserSessionState.idle, notify: false);
    _completeGate(false);
    notifyListeners();
  }

  /// Full sign-out: drop the session and clear every WebView-side store.
  Future<void> signOut() async {
    final controller = _controller;
    try {
      await controller?.clearCache();
      await controller?.clearLocalStorage();
    } catch (error) {
      _log('webview store clear failed: ${error.runtimeType}');
    }
    try {
      await WebViewCookieManager().clearCookies();
    } catch (error) {
      _log('cookie clear failed: ${error.runtimeType}');
    }

    _teardown(BrowserErrorCategory.notAuthenticated);
    _setState(BrowserSessionState.idle, notify: false);
    _completeGate(false);
    _log('browser session signed out');
    notifyListeners();
  }

  /// Reloads sokker.org in the existing session.
  Future<void> reload() async {
    final controller = _controller;
    if (controller == null) return;
    _failureMessage = null;
    _setState(BrowserSessionState.loading);
    try {
      await controller.loadRequest(Uri.parse(_homeUrl));
    } catch (error) {
      _log('reload failed: ${error.runtimeType}');
      _failureMessage = 'The page could not be reloaded.';
      _setState(BrowserSessionState.failed);
    }
  }

  /// In-page back navigation, so the user can escape a dead end without
  /// losing the session.
  Future<bool> goBack() async {
    final controller = _controller;
    if (controller == null) return false;
    if (!await controller.canGoBack()) return false;
    await controller.goBack();
    return true;
  }

  void _teardown(BrowserErrorCategory reason) {
    _probeTimer?.cancel();
    _probeTimer = null;
    _probeFuture = null;
    _lastProbeAt = null;
    _accountName = null;
    _visible = false;
    _controller = null;
    _failAllPending(reason);
  }

  // ---------------------------------------------------------------------
  // WebView wiring
  // ---------------------------------------------------------------------

  WebViewController _createController() {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: _onPageStarted,
          onPageFinished: _onPageFinished,
          onWebResourceError: _onWebResourceError,
          onHttpError: _onHttpError,
        ),
      );
    controller.addJavaScriptChannel(
      _channelName,
      onMessageReceived: _onBridgeMessage,
    );
    return controller;
  }

  Future<void> _loadHome() async {
    try {
      await _controller?.loadRequest(Uri.parse(_homeUrl));
    } catch (error) {
      _log('initial load failed: ${error.runtimeType}');
      _failureMessage = 'sokker.org could not be opened.';
      _setState(BrowserSessionState.failed);
    }
  }

  void _onPageStarted(String url) {
    _pageLoading = true;
    _failureMessage = null;
    if (_state != BrowserSessionState.ready) {
      _setState(BrowserSessionState.loading, notify: false);
    }
    _log('page started: ${_safeUrl(url)}');
    notifyListeners();
  }

  Future<void> _onPageFinished(String url) async {
    _pageLoading = false;

    final title = (await _controller?.getTitle() ?? '').toLowerCase();
    final challenge = _looksLikeChallengeTitle(title) ||
        Uri.tryParse(url)?.host == 'challenges.cloudflare.com';

    _log('page finished: ${_safeUrl(url)} challenge=$challenge');

    if (challenge) {
      _accountName = null;
      _setState(BrowserSessionState.challenge);
      return;
    }

    if (_state != BrowserSessionState.ready) {
      _setState(BrowserSessionState.loading, notify: false);
    }
    notifyListeners();

    // One debounced probe per page settle — never a polling loop.
    _scheduleProbe();
  }

  void _onWebResourceError(WebResourceError error) {
    if (error.isForMainFrame == false) return;
    _pageLoading = false;
    _log('web resource error: code=${error.errorCode} '
        'type=${error.errorType?.name ?? 'unknown'}');
    _failureMessage = 'The page could not be loaded.';
    if (_state != BrowserSessionState.ready) {
      _setState(BrowserSessionState.failed);
    } else {
      notifyListeners();
    }
  }

  void _onHttpError(HttpResponseError error) {
    _log('page http error: status=${error.response?.statusCode}');
  }

  bool _looksLikeChallengeTitle(String title) =>
      title.contains('just a moment') ||
      title.contains('attention required') ||
      title.contains('checking your browser') ||
      title.contains('security check');

  // ---------------------------------------------------------------------
  // Authentication probe
  // ---------------------------------------------------------------------

  void _scheduleProbe() {
    if (_probeFuture != null || _probeTimer != null) return;
    final last = _lastProbeAt;
    if (last != null && DateTime.now().difference(last) < _probeCooldown) {
      return;
    }
    _probeTimer = Timer(_probeDelay, () {
      _probeTimer = null;
      unawaited(probeCurrentUser());
    });
  }

  /// Asks `/api/current` inside the browser session and updates the state.
  ///
  /// Guarded so overlapping page loads and repeated taps cannot stack probes:
  /// callers that arrive while a probe is running share its result instead of
  /// starting a second one.
  Future<BrowserApiResult> probeCurrentUser() {
    return _probeFuture ??= _runProbe();
  }

  Future<BrowserApiResult> _runProbe() async {
    _lastProbeAt = DateTime.now();
    try {
      final result = await request(userUrl, updateSessionState: false);

      if (result.isSuccess) {
        final data = result.decodedData;
        _accountName = data is Map<String, dynamic> ? data['name'] as String? : null;
        _failureMessage = null;
        _setState(BrowserSessionState.ready);
      } else if (result.isCloudflareChallenge) {
        _accountName = null;
        _setState(BrowserSessionState.challenge);
      } else if (result.errorCategory == BrowserErrorCategory.notAuthenticated ||
          result.errorCategory == BrowserErrorCategory.forbidden) {
        _accountName = null;
        _setState(BrowserSessionState.needsLogin);
      } else {
        _failureMessage = result.userMessage;
        if (_state != BrowserSessionState.ready) {
          _setState(BrowserSessionState.failed);
        } else {
          notifyListeners();
        }
      }
      return result;
    } finally {
      _probeFuture = null;
      _lastProbeAt = DateTime.now();
    }
  }

  // ---------------------------------------------------------------------
  // Browser-backed transport
  // ---------------------------------------------------------------------

  /// Executes one allowlisted same-origin request inside the browser session.
  ///
  /// [endpoint] must resolve to a path on the allowlist in
  /// `sokker_endpoints.dart`; anything else fails with
  /// [BrowserErrorCategory.unsupportedEndpoint] without reaching JavaScript.
  Future<BrowserApiResult> request(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    bool updateSessionState = true,
  }) async {
    final resolved = resolveAllowedEndpoint(
      endpoint,
      queryParameters: queryParameters,
    );
    if (resolved == null) {
      _log('rejected non-allowlisted endpoint');
      return BrowserApiResult.failure(
        BrowserErrorCategory.unsupportedEndpoint,
      );
    }

    final controller = _controller;
    if (controller == null) {
      return BrowserApiResult.failure(
        BrowserErrorCategory.webViewFailure,
      );
    }

    await _acquireSlot();
    final id = '${_nextRequestId++}';
    final completer = Completer<BrowserApiResult>();
    _pending[id] = completer;

    BrowserApiResult result;
    try {
      await controller.runJavaScript(_bridgeScript(id, resolved));
      result = await completer.future.timeout(
        _requestTimeout,
        onTimeout: () => BrowserApiResult.failure(
          BrowserErrorCategory.timeout,
        ),
      );
    } catch (error) {
      _log('bridge invocation failed: ${error.runtimeType}');
      result = BrowserApiResult.failure(
        BrowserErrorCategory.webViewFailure,
      );
    } finally {
      _pending.remove(id);
      _releaseSlot();
    }

    // Log the path only: query strings carry team and player ids.
    final loggedPath = resolved.split('?').first;
    _log('$loggedPath -> $result');
    if (updateSessionState) _applySideEffects(result);
    return result;
  }

  /// A stale or challenged session must surface, not fail silently.
  void _applySideEffects(BrowserApiResult result) {
    if (result.isSuccess) return;
    switch (result.errorCategory) {
      case BrowserErrorCategory.cloudflareChallenge:
        _setState(BrowserSessionState.challenge);
        show();
        break;
      case BrowserErrorCategory.notAuthenticated:
      case BrowserErrorCategory.forbidden:
        _accountName = null;
        _setState(BrowserSessionState.needsLogin);
        show();
        break;
      default:
        break;
    }
  }

  Future<void> _acquireSlot() {
    if (_inFlight < _maxConcurrentRequests) {
      _inFlight++;
      return Future<void>.value();
    }
    final waiter = Completer<void>();
    _waiting.add(waiter);
    return waiter.future;
  }

  void _releaseSlot() {
    if (_waiting.isNotEmpty) {
      _waiting.removeFirst().complete();
    } else if (_inFlight > 0) {
      _inFlight--;
    }
  }

  void _failAllPending(BrowserErrorCategory category) {
    final pending = List<Completer<BrowserApiResult>>.from(_pending.values);
    _pending.clear();
    for (final completer in pending) {
      if (!completer.isCompleted) {
        completer.complete(BrowserApiResult.failure(category));
      }
    }
    while (_waiting.isNotEmpty) {
      final waiter = _waiting.removeFirst();
      if (!waiter.isCompleted) waiter.complete();
    }
    _inFlight = 0;
  }

  void _onBridgeMessage(JavaScriptMessage message) {
    Object? payload;
    try {
      payload = jsonDecode(message.message);
    } catch (_) {
      _log('bridge sent an unparsable message');
      return;
    }
    if (payload is! Map<String, dynamic>) return;

    final id = payload['id'];
    if (id is! String) return;

    final completer = _pending.remove(id);
    if (completer == null || completer.isCompleted) return;
    completer.complete(_resultFrom(payload));
  }

  BrowserApiResult _resultFrom(Map<String, dynamic> payload) {
    final status = payload['status'] is int ? payload['status'] as int : null;
    final category = payload['category'];
    if (category is String) {
      return BrowserApiResult.failure(
        _categoryFromName(category),
        status: status,
      );
    }

    final isJson = payload['isJson'] == true;
    final challenge = payload['challenge'] == true;

    if (challenge) {
      return BrowserApiResult.failure(
        BrowserErrorCategory.cloudflareChallenge,
        status: status,
      );
    }
    if (status == 200 && isJson) {
      return BrowserApiResult(
        statusCode: status,
        isJson: true,
        isAuthenticated: true,
        decodedData: payload['data'],
      );
    }
    if (status == 401) {
      return BrowserApiResult.failure(
        BrowserErrorCategory.notAuthenticated,
        status: status,
      );
    }
    if (status == 403) {
      return BrowserApiResult.failure(
        BrowserErrorCategory.forbidden,
        status: status,
      );
    }
    if (!isJson) {
      // An HTML body where JSON was expected means Sokker served a page —
      // in practice the sign-in page. The body itself is never returned.
      return BrowserApiResult.failure(
        BrowserErrorCategory.notAuthenticated,
        status: status,
      );
    }
    return BrowserApiResult.failure(
      BrowserErrorCategory.unexpectedResponse,
      status: status,
    );
  }

  BrowserErrorCategory _categoryFromName(String name) {
    for (final category in BrowserErrorCategory.values) {
      if (category.name == name) return category;
    }
    return BrowserErrorCategory.unexpectedResponse;
  }

  /// Builds the bridge invocation.
  ///
  /// The request is passed as a base64 JSON blob so no caller-supplied text is
  /// ever concatenated into JavaScript source. The script re-checks the origin
  /// before issuing the fetch and returns only a classification plus, for JSON
  /// responses, the decoded payload.
  String _bridgeScript(String id, String resolvedPath) {
    final payload = base64Encode(
      utf8.encode(jsonEncode(<String, String>{'id': id, 'path': resolvedPath})),
    );

    return '''
(function () {
  var encoded = '$payload';
  function reply(message) {
    try { $_channelName.postMessage(JSON.stringify(message)); } catch (e) {}
  }
  var req;
  try {
    var bytes = Uint8Array.from(atob(encoded), function (c) { return c.charCodeAt(0); });
    req = JSON.parse(new TextDecoder().decode(bytes));
  } catch (e) {
    reply({ id: null, category: 'webViewFailure' });
    return;
  }
  var id = req.id;
  var url;
  try {
    url = new URL(req.path, location.origin);
  } catch (e) {
    reply({ id: id, category: 'unsupportedEndpoint' });
    return;
  }
  if (url.origin !== '$sokkerOrigin') {
    reply({ id: id, category: 'unsupportedEndpoint' });
    return;
  }
  fetch(url.toString(), {
    method: 'GET',
    credentials: 'include',
    redirect: 'follow',
    headers: { 'Accept': 'application/json' }
  }).then(function (response) {
    var type = (response.headers.get('content-type') || '').toLowerCase();
    var isJson = type.indexOf('json') !== -1;
    if (isJson) {
      return response.json().then(function (data) {
        // Only a successful payload crosses the bridge; error bodies are
        // classified by status alone.
        var ok = response.status === 200;
        reply({ id: id, status: response.status, isJson: true, challenge: false, data: ok ? data : null });
      }, function () {
        reply({ id: id, status: response.status, isJson: true, category: 'malformedJson' });
      });
    }
    return response.text().then(function (text) {
      var challenge = /just a moment|challenges[.]cloudflare[.]com|cf-chl|cf-browser-verification/i.test(text);
      reply({ id: id, status: response.status, isJson: false, challenge: challenge });
    }, function () {
      reply({ id: id, status: response.status, isJson: false, challenge: false });
    });
  }, function () {
    reply({ id: id, category: 'networkError' });
  });
})();
''';
  }

  // ---------------------------------------------------------------------

  void _setState(BrowserSessionState next, {bool notify = true}) {
    if (_state != next) {
      _state = next;
      _log('state -> ${next.name}');
    }
    if (notify) notifyListeners();
  }

  void _completeGate(bool value) {
    final gate = _gate;
    _gate = null;
    if (gate != null && !gate.isCompleted) gate.complete(value);
  }

  /// Logs only the path of a URL — never query strings, which can carry ids.
  String _safeUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return '<unparsable>';
    return '${uri.host}${uri.path}';
  }

  void _log(String message) {
    if (kDebugMode) debugPrint('[browser-session] $message');
  }

  @override
  void dispose() {
    _probeTimer?.cancel();
    _failAllPending(BrowserErrorCategory.webViewFailure);
    super.dispose();
  }
}
