import 'package:json_annotation/json_annotation.dart';

import 'news_block.dart';

part 'news_item.g.dart';

@JsonSerializable()
class NewsItem {
  final int id;
  final Author author;
  final int type;
  final String kind;
  final String title;
  final List<dynamic> titleProperties;
  final NewsDate date;
  final bool unread;
  final List<NewsBlock> blocks;

  NewsItem({
    required this.id,
    required this.author,
    required this.type,
    required this.kind,
    required this.title,
    required this.titleProperties,
    required this.date,
    required this.unread,
    required this.blocks,
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) =>
      _$NewsItemFromJson(json);
  Map<String, dynamic> toJson() => _$NewsItemToJson(this);
}

@JsonSerializable()
class Author {
  final String name;

  Author({
    required this.name,
  });

  factory Author.fromJson(Map<String, dynamic> json) => _$AuthorFromJson(json);
  Map<String, dynamic> toJson() => _$AuthorToJson(this);
}

@JsonSerializable()
class NewsDate {
  final String value;
  final String dateTime;
  final int timestamp;

  NewsDate({
    required this.value,
    required this.dateTime,
    required this.timestamp,
  });

  factory NewsDate.fromJson(Map<String, dynamic> json) =>
      _$NewsDateFromJson(json);
  Map<String, dynamic> toJson() => _$NewsDateToJson(this);
}
