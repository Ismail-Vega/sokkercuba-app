/// The only origin the browser transport may ever talk to.
const String sokkerOrigin = 'https://sokker.org';
const String sokkerHost = 'sokker.org';

/// Allowlist of Sokker API paths the browser transport may request.
///
/// Every path here is one the app already calls through [ApiClient]; see
/// `constants.dart`, `fetch_all_data.dart`, `fetch_juniors_*.dart` and
/// `transfers.dart`. Anything not matched stays on the native Dio transport.
///
/// `/api/auth/login` is deliberately absent: credentials are never pushed into
/// the WebView. Legacy form endpoints (`/mailbox.php`, `/sent.php`) are absent
/// too — they are not JSON APIs.
final List<RegExp> _allowedPaths = <RegExp>[
  RegExp(r'^/api/current$'),
  RegExp(r'^/api/junior$'),
  RegExp(r'^/api/junior/[0-9]+/graph$'),
  RegExp(r'^/api/training$'),
  RegExp(r'^/api/training/summary$'),
  RegExp(r'^/api/training/[0-9]+/report$'),
  RegExp(r'^/api/trainer$'),
  RegExp(r'^/api/player$'),
  RegExp(r'^/api/team/[0-9]+/stats$'),
  RegExp(r'^/api/news$'),
  RegExp(r'^/api/news/[0-9]+$'),
  RegExp(r'^/api/transfer$'),
];

/// Characters accepted in a query string.
///
/// This is RFC 3986's query set minus the quote characters: Sokker only ever
/// uses `filter[...]=value`, so anything more exotic is rejected rather than
/// escaped.
final RegExp _safeQuery = RegExp(r'^[A-Za-z0-9\-._~%!$&()*+,;=:@/?\[\]]*$');

/// Resolves [endpoint] to a same-origin `path?query` string when it is on the
/// allowlist, or returns `null` when it is not.
///
/// Accepts the relative paths the app already uses and, defensively, absolute
/// `https://sokker.org/...` URLs.
///
/// The query is carried through as raw text rather than through [Uri], which
/// would percent-encode the brackets in Sokker's `filter[team]=1` syntax.
String? resolveAllowedEndpoint(
  String endpoint, {
  Map<String, dynamic>? queryParameters,
}) {
  if (endpoint.contains('#')) return null;

  final split = endpoint.indexOf('?');
  final head = split == -1 ? endpoint : endpoint.substring(0, split);
  final rawQuery = split == -1 ? '' : endpoint.substring(split + 1);

  if (head.contains('..')) return null;

  final uri = Uri.tryParse(head);
  if (uri == null) return null;

  if (uri.hasScheme || uri.hasAuthority) {
    if (uri.scheme != 'https') return null;
    if (uri.host != sokkerHost) return null;
    if (uri.hasPort && uri.port != 443) return null;
    if (uri.userInfo.isNotEmpty) return null;
  }

  final path = uri.path;
  if (!path.startsWith('/')) return null;
  if (path.contains('..') || path.contains('//')) return null;
  if (!_allowedPaths.any((pattern) => pattern.hasMatch(path))) return null;

  final parts = <String>[];
  if (rawQuery.isNotEmpty) {
    if (!_safeQuery.hasMatch(rawQuery)) return null;
    parts.add(rawQuery);
  }
  if (queryParameters != null) {
    for (final entry in queryParameters.entries) {
      final key = Uri.encodeQueryComponent(entry.key);
      final value = Uri.encodeQueryComponent('${entry.value}');
      parts.add('$key=$value');
    }
  }

  return parts.isEmpty ? path : '$path?${parts.join('&')}';
}

/// Whether [endpoint] can be served by the browser transport.
bool isAllowedEndpoint(String endpoint,
        {Map<String, dynamic>? queryParameters}) =>
    resolveAllowedEndpoint(endpoint, queryParameters: queryParameters) != null;
