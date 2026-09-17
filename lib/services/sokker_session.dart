import 'api_client.dart';
import 'browser/browser_session.dart';

/// Makes sure some authenticated transport is available before a data load.
///
/// Returns `true` when it is safe to call `fetchAllData`:
///  * a confirmed browser session already exists, or
///  * the native Dio session still works, or
///  * Cloudflare blocked the native request and the user completed the
///    in-app browser session.
///
/// Returns `false` when the user is genuinely signed out, offline, or
/// abandoned the browser session.
Future<bool> ensureSokkerSession(ApiClient apiClient) async {
  if (BrowserSession.instance.isReady) return true;

  final probe = await apiClient.probeNativeSession();
  switch (probe.status) {
    case NativeSessionStatus.authenticated:
      return true;
    case NativeSessionStatus.cloudflareBlocked:
      return BrowserSession.instance.ensureReady();
    case NativeSessionStatus.unauthenticated:
    case NativeSessionStatus.networkError:
      return false;
  }
}
