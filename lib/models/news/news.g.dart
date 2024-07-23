// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

News _$NewsFromJson(Map<String, dynamic> json) => News(
      news: (json['news'] as List<dynamic>)
          .map((e) => NewsItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      juniors: (json['juniors'] as List<dynamic>)
          .map((e) => NewsJunior.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$NewsToJson(News instance) => <String, dynamic>{
      'news': instance.news,
      'juniors': instance.juniors,
      'total': instance.total,
    };
