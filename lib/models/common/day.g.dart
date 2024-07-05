// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Day _$DayFromJson(Map<String, dynamic> json) => Day(
      season: (json['season'] as num).toInt(),
      week: (json['week'] as num).toInt(),
      seasonWeek: (json['seasonWeek'] as num).toInt(),
      day: (json['day'] as num).toInt(),
      date: DateValue.fromJson(json['date'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DayToJson(Day instance) => <String, dynamic>{
      'season': instance.season,
      'week': instance.week,
      'seasonWeek': instance.seasonWeek,
      'day': instance.day,
      'date': instance.date,
    };
