import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../constants/constants.dart';
import '../main.dart';
import '../services/api_client.dart';
import '../services/browser/browser_session.dart';
import '../services/fetch_all_data.dart';
import '../state/actions.dart';
import '../state/app_state_notifier.dart';

/// Keeps the one Sokker browser session mounted for the whole app.
///
/// The WebView is never a route. It lives in a root [Stack] and moves between
/// two slots by [GlobalKey], which reparents the element without recreating the
/// platform view:
///
///  * hidden — a 1x1 slot in the top-left corner, so WKWebView stays in the
///    window hierarchy and its JavaScript keeps running at full speed;
///  * visible — full screen, wrapped in the sign-in chrome.
///
/// Because it is not a route there is no Navigator result to get wrong, and the
/// user never has to close it and go back to the native login form.
class BrowserSessionHost extends StatelessWidget {
  const BrowserSessionHost({super.key, required this.child});

  final Widget child;

  static final GlobalKey _webViewKey = GlobalKey(debugLabel: 'sokkerWebView');

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: BrowserSession.instance,
      builder: (context, _) {
        final session = BrowserSession.instance;
        final controller = session.controller;

        if (controller == null) return child;

        final webView = WebViewWidget(
          key: _webViewKey,
          controller: controller,
        );

        return Stack(
          children: [
            child,
            if (session.isVisible)
              Positioned.fill(
                child: _BrowserSessionScreen(session: session, webView: webView),
              )
            else
              // Parked, not unmounted: the session and its cookies stay alive.
              Positioned(
                left: 0,
                top: 0,
                width: 1,
                height: 1,
                child: IgnorePointer(
                  child: ExcludeSemantics(child: webView),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _BrowserSessionScreen extends StatefulWidget {
  const _BrowserSessionScreen({required this.session, required this.webView});

  final BrowserSession session;
  final Widget webView;

  @override
  State<_BrowserSessionScreen> createState() => _BrowserSessionScreenState();
}

class _BrowserSessionScreenState extends State<_BrowserSessionScreen> {
  bool _busy = false;
  String? _message;

  BrowserSession get _session => widget.session;

  @override
  Widget build(BuildContext context) {
    final state = _session.state;
    final canContinue = state == BrowserSessionState.ready && !_busy;
    final showProgress = _busy || _session.isPageLoading;

    return Material(
      color: Colors.blue[900],
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            if (showProgress) const LinearProgressIndicator(minHeight: 2),
            _buildStatusBar(state),
            _buildActions(canContinue),
            Expanded(
              child: ColoredBox(
                color: Colors.white,
                child: widget.webView,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            tooltip: 'Previous page',
            onPressed: _busy ? null : () => _session.goBack(),
          ),
          const Expanded(
            child: Text(
              'Sokker sign-in',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'Reload sokker.org',
            onPressed: _busy ? null : () => _session.reload(),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            tooltip: 'Cancel sign-in',
            onPressed: _busy ? null : _cancel,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBar(BrowserSessionState state) {
    final message = _message ?? _defaultMessage(state);
    final isError = _message != null && state != BrowserSessionState.ready;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: isError ? Colors.red[700] : Colors.black26,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(_iconFor(state, isError), size: 18, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconFor(BrowserSessionState state, bool isError) {
    if (isError) return Icons.error_outline;
    switch (state) {
      case BrowserSessionState.ready:
        return Icons.verified_user_outlined;
      case BrowserSessionState.challenge:
        return Icons.shield_outlined;
      case BrowserSessionState.needsLogin:
        return Icons.login;
      case BrowserSessionState.failed:
        return Icons.error_outline;
      case BrowserSessionState.idle:
      case BrowserSessionState.loading:
        return Icons.hourglass_empty;
    }
  }

  String _defaultMessage(BrowserSessionState state) {
    switch (state) {
      case BrowserSessionState.idle:
      case BrowserSessionState.loading:
        return 'Opening sokker.org…';
      case BrowserSessionState.challenge:
        return 'Sokker is asking for human verification. '
            'Complete the check below to continue.';
      case BrowserSessionState.needsLogin:
        return 'Verification done. Sign in to Sokker in the page below — '
            'the app detects it automatically.';
      case BrowserSessionState.ready:
        final name = _session.accountName;
        return name == null
            ? 'Session ready. Continue to the app.'
            : 'Signed in as $name. Continue to the app.';
      case BrowserSessionState.failed:
        return _session.failureMessage ?? 'The page could not be loaded.';
    }
  }

  Widget _buildActions(bool canContinue) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              icon: const Icon(Icons.sync, size: 18),
              label: const Text('Check again'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white54),
              ),
              onPressed: _busy ? null : _checkAgain,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FilledButton.icon(
              icon: const Icon(Icons.arrow_forward, size: 18),
              label: Text(_busy ? 'Loading data…' : 'Continue to app'),
              onPressed: canContinue ? _continueToApp : null,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _checkAgain() async {
    setState(() {
      _busy = true;
      _message = null;
    });
    final result = await _session.probeCurrentUser();
    if (!mounted) return;
    setState(() {
      _busy = false;
      _message = result.isSuccess ? null : result.userMessage;
    });
  }

  void _cancel() {
    _session.abandon();
  }

  /// Proves the transport, then loads the app's data through it.
  ///
  /// The app only becomes "logged in" when all three steps pass: the session is
  /// confirmed by `/api/current`, a second endpoint answers through the same
  /// browser session, and the full initial load succeeds.
  Future<void> _continueToApp() async {
    setState(() {
      _busy = true;
      _message = null;
    });

    final notifier = Provider.of<AppStateNotifier>(context, listen: false);

    try {
      final confirmation = await _session.probeCurrentUser();
      if (!confirmation.isSuccess) {
        _fail(confirmation.userMessage);
        return;
      }

      // Second endpoint: proves the transport is not a one-off for /api/current.
      final probe = await _session.request(juniorsUrl);
      if (!probe.isSuccess) {
        _fail(probe.userMessage);
        return;
      }

      if (!mounted) return;
      final apiClient = ApiClient();
      await apiClient.initCookieJar();

      if (!mounted) return;
      final result = await fetchAllData(apiClient, notifier, context);

      if (result['code'] == 200 && result['success'] == true) {
        notifier.dispatch(
          StoreAction(StoreActionTypes.setUsername, _session.accountName ?? ''),
        );
        notifier.dispatch(StoreAction(StoreActionTypes.setLogin, true));
        _session.completeSession();
        navigatorKey.currentState
            ?.pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
        return;
      }

      _fail(result['message']?.toString() ??
          'Sokker data could not be loaded. Please try again.');
    } catch (error) {
      _fail('Sokker data could not be loaded. Please try again.');
    }
  }

  void _fail(String message) {
    if (!mounted) return;
    setState(() {
      _busy = false;
      _message = message;
    });
  }
}
