// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Stats _$StatsFromJson(Map<String, dynamic> json) => Stats(
      cards: (json['cards'] as num).toInt(),
      yellow: (json['yellow'] as num).toInt(),
      red: (json['red'] as num).toInt(),
      goals: (json['goals'] as num).toInt(),
      assists: (json['assists'] as num).toInt(),
      matches: (json['matches'] as num).toInt(),
    );

Map<String, dynamic> _$StatsToJson(Stats instance) => <String, dynamic>{
      'cards': instance.cards,
      'yellow': instance.yellow,
      'red': instance.red,
      'goals': instance.goals,
      'assists': instance.assists,
      'matches': instance.matches,
    };
