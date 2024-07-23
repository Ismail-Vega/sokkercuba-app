import '../models/news/news_item.dart';
import '../models/news/news_junior.dart';
import '../utils/constants.dart';
import 'api_client.dart';

Future<List<NewsJunior>> getJuniorNews(
    ApiClient apiClient, List<NewsItem> news) async {
  if (news.isEmpty) return [];

  final responses = await Future.wait(
      news.map((item) => apiClient.fetchData(getJuniorNewsURL(item.id))));

  final juniors = responses
      .expand((res) => res['blocks'] ?? [])
      .where((block) =>
          block['type'] == 'juniors' && block['data']?['juniors'] != null)
      .expand((block) => block['data']?['juniors'])
      .map((junior) => NewsJunior.fromJson(junior))
      .toList();

  return juniors;
}
