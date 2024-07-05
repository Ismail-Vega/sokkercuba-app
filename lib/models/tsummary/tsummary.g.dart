// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tsummary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameDay _$GameDayFromJson(Map<String, dynamic> json) => GameDay(
      season: (json['season'] as num).toInt(),
      week: (json['week'] as num).toInt(),
      seasonWeek: (json['seasonWeek'] as num).toInt(),
      day: (json['day'] as num).toInt(),
      date: DateValue.fromJson(json['date'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GameDayToJson(GameDay instance) => <String, dynamic>{
      'season': instance.season,
      'week': instance.week,
      'seasonWeek': instance.seasonWeek,
      'day': instance.day,
      'date': instance.date,
    };

Week _$WeekFromJson(Map<String, dynamic> json) => Week(
      gameDay: GameDay.fromJson(json['gameDay'] as Map<String, dynamic>),
      week: (json['week'] as num).toInt(),
      stats: Stats.fromJson(json['stats'] as Map<String, dynamic>),
      juniors: Juniors.fromJson(json['juniors'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WeekToJson(Week instance) => <String, dynamic>{
      'gameDay': instance.gameDay,
      'week': instance.week,
      'stats': instance.stats,
      'juniors': instance.juniors,
    };

TSummary _$TSummaryFromJson(Map<String, dynamic> json) => TSummary(
      weeks: (json['weeks'] as List<dynamic>)
          .map((e) => Week.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TSummaryToJson(TSummary instance) => <String, dynamic>{
      'weeks': instance.weeks,
    };
