/// Classification of a failed browser-backed request.
///
/// Categories are deliberately coarse: they are safe to log and safe to map to
/// a user-facing message. They never carry server content.
enum BrowserErrorCategory {
  /// Cloudflare served a challenge instead of the API response.
  cloudflareChallenge,

  /// The browser session reached Sokker but is not signed in (401, or an HTML
  /// page returned where JSON was expected).
  notAuthenticated,

  /// Sokker answered 403 without a Cloudflare challenge.
  forbidden,

  /// `fetch` itself failed inside the page (offline, DNS, aborted).
  networkError,

  /// The response claimed to be JSON but could not be parsed.
  malformedJson,

  /// The endpoint is not on the Dart-side allowlist.
  unsupportedEndpoint,

  /// The WebView could not run the bridge at all.
  webViewFailure,

  /// No reply arrived from the bridge in time.
  timeout,

  /// A well-formed response that does not fit any expected shape.
  unexpectedResponse,
}

/// Result of one allowlisted request executed inside the Sokker browser
/// session.
///
/// This is the only data that crosses back from the WebView into Dart. It
/// never contains cookies, tokens, raw HTML or challenge markup.
class BrowserApiResult {
  const BrowserApiResult({
    this.statusCode,
    this.isCloudflareChallenge = false,
    this.isAuthenticated = false,
    this.isJson = false,
    this.decodedData,
    this.errorCategory,
  });

  BrowserApiResult.failure(BrowserErrorCategory category, {int? status})
      : statusCode = status,
        isCloudflareChallenge =
            category == BrowserErrorCategory.cloudflareChallenge,
        isAuthenticated = false,
        isJson = false,
        decodedData = null,
        errorCategory = category;

  final int? statusCode;
  final bool isCloudflareChallenge;
  final bool isAuthenticated;
  final bool isJson;
  final Object? decodedData;
  final BrowserErrorCategory? errorCategory;

  bool get isSuccess => errorCategory == null && isAuthenticated;

  /// A single safe log line: never includes the payload.
  @override
  String toString() => 'status=$statusCode json=$isJson '
      'cf=$isCloudflareChallenge auth=$isAuthenticated '
      'error=${errorCategory?.name ?? 'none'}';

  /// Short message suitable for showing to the user.
  String get userMessage {
    switch (errorCategory) {
      case BrowserErrorCategory.cloudflareChallenge:
        return 'Cloudflare is still asking for verification. '
            'Complete the check in the page below.';
      case BrowserErrorCategory.notAuthenticated:
        return 'This browser session is not signed in to Sokker yet.';
      case BrowserErrorCategory.forbidden:
        return 'Sokker refused this request for the current session.';
      case BrowserErrorCategory.networkError:
        return 'The request could not reach Sokker. Check your connection.';
      case BrowserErrorCategory.malformedJson:
        return 'Sokker returned data the app could not read.';
      case BrowserErrorCategory.unsupportedEndpoint:
        return 'This request is not allowed through the browser session.';
      case BrowserErrorCategory.webViewFailure:
        return 'The in-app browser could not run the request.';
      case BrowserErrorCategory.timeout:
        return 'Sokker did not answer in time. Please try again.';
      case BrowserErrorCategory.unexpectedResponse:
        return 'Sokker returned an unexpected response.';
      case null:
        return 'Request completed.';
    }
  }
}
