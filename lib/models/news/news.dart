import 'package:json_annotation/json_annotation.dart';

import 'news_item.dart';
import 'news_junior.dart';

part 'news.g.dart';

@JsonSerializable()
class News {
  final List<NewsItem> news;
  final List<NewsJunior> juniors;
  final int total;

  News({
    required this.news,
    required this.juniors,
    required this.total,
  });

  factory News.fromJson(Map<String, dynamic> json) => _$NewsFromJson(json);
  Map<String, dynamic> toJson() => _$NewsToJson(this);
}
