// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsItem _$NewsItemFromJson(Map<String, dynamic> json) => NewsItem(
      id: (json['id'] as num).toInt(),
      author: Author.fromJson(json['author'] as Map<String, dynamic>),
      type: (json['type'] as num).toInt(),
      kind: json['kind'] as String,
      title: json['title'] as String,
      titleProperties: json['titleProperties'] as List<dynamic>,
      date: NewsDate.fromJson(json['date'] as Map<String, dynamic>),
      unread: json['unread'] as bool,
      blocks: (json['blocks'] as List<dynamic>)
          .map((e) => NewsBlock.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$NewsItemToJson(NewsItem instance) => <String, dynamic>{
      'id': instance.id,
      'author': instance.author,
      'type': instance.type,
      'kind': instance.kind,
      'title': instance.title,
      'titleProperties': instance.titleProperties,
      'date': instance.date,
      'unread': instance.unread,
      'blocks': instance.blocks,
    };

Author _$AuthorFromJson(Map<String, dynamic> json) => Author(
      name: json['name'] as String,
    );

Map<String, dynamic> _$AuthorToJson(Author instance) => <String, dynamic>{
      'name': instance.name,
    };

NewsDate _$NewsDateFromJson(Map<String, dynamic> json) => NewsDate(
      value: json['value'] as String,
      dateTime: json['dateTime'] as String,
      timestamp: (json['timestamp'] as num).toInt(),
    );

Map<String, dynamic> _$NewsDateToJson(NewsDate instance) => <String, dynamic>{
      'value': instance.value,
      'dateTime': instance.dateTime,
      'timestamp': instance.timestamp,
    };
