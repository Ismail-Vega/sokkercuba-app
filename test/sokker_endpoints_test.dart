import 'package:flutter_test/flutter_test.dart';
import 'package:sokker_pro/constants/constants.dart';
import 'package:sokker_pro/services/browser/sokker_endpoints.dart';

void main() {
  group('resolveAllowedEndpoint accepts the endpoints the app actually uses',
      () {
    test('the constants used by fetch_all_data', () {
      for (final endpoint in <String>[
        userUrl,
        juniorsUrl,
        trainingUrl,
        tsummaryUrl,
        '/api/trainer',
      ]) {
        expect(resolveAllowedEndpoint(endpoint), endpoint, reason: endpoint);
      }
    });

    test('the id-parameterised builders', () {
      expect(resolveAllowedEndpoint(getPlayerFullReportURL(42)),
          '/api/training/42/report');
      expect(resolveAllowedEndpoint(getJuniorGraphUrl(7)), '/api/junior/7/graph');
      expect(resolveAllowedEndpoint(getTeamStatsURL(1234)),
          '/api/team/1234/stats');
      expect(resolveAllowedEndpoint(getJuniorNewsURL(99)), '/api/news/99');
    });

    test('Sokker filter query syntax survives verbatim', () {
      expect(
        resolveAllowedEndpoint(getTeamPlayersURL(555)),
        '/api/player?filter[team]=555&filter[limit]=200&filter[offset]=0',
      );
      expect(resolveAllowedEndpoint(newsUrl), '/api/news?filter[limit]=200');
      expect(
        resolveAllowedEndpoint(
          '/api/transfer?filter[offset]=0&filter[limit]=200&filter[includeEnded]=true',
        ),
        '/api/transfer?filter[offset]=0&filter[limit]=200&filter[includeEnded]=true',
      );
    });

    test('extra query parameters are appended and encoded', () {
      expect(
        resolveAllowedEndpoint('/api/news', queryParameters: {'limit': 10}),
        '/api/news?limit=10',
      );
      expect(
        resolveAllowedEndpoint('/api/news?a=1', queryParameters: {'b': 'x y'}),
        '/api/news?a=1&b=x+y',
      );
    });

    test('an absolute sokker.org https url is accepted', () {
      expect(resolveAllowedEndpoint('https://sokker.org/api/current'),
          '/api/current');
    });
  });

  group('resolveAllowedEndpoint rejects everything else', () {
    test('other origins, schemes and ports', () {
      for (final endpoint in <String>[
        'https://evil.example/api/current',
        'https://sokker.org.evil.example/api/current',
        'http://sokker.org/api/current',
        'https://sokker.org:8443/api/current',
        'https://user:pass@sokker.org/api/current',
        '//evil.example/api/current',
        'javascript:alert(1)',
      ]) {
        expect(resolveAllowedEndpoint(endpoint), isNull, reason: endpoint);
      }
    });

    test('paths outside the API surface', () {
      for (final endpoint in <String>[
        loginUrl,
        '/api/auth/logout',
        '/mailbox.php',
        '/sent.php',
        '/index/action/start',
        '/api/national?action=addplayer&PID=1',
        '/api/current/../../admin',
        '/api/currentx',
        'api/current',
        '',
      ]) {
        expect(resolveAllowedEndpoint(endpoint), isNull, reason: endpoint);
      }
    });

    test('fragments and unsafe query characters', () {
      expect(resolveAllowedEndpoint('/api/current#frag'), isNull);
      expect(resolveAllowedEndpoint("/api/news?q='+alert(1)+'"), isNull);
      expect(resolveAllowedEndpoint('/api/news?q=a"b'), isNull);
      expect(resolveAllowedEndpoint(r'/api/news?q=a\b'), isNull);
    });
  });

  test('isAllowedEndpoint mirrors resolveAllowedEndpoint', () {
    expect(isAllowedEndpoint(userUrl), isTrue);
    expect(isAllowedEndpoint(loginUrl), isFalse);
  });
}
