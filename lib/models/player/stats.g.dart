// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Stats _$StatsFromJson(Map<String, dynamic> json) => Stats(
      assists: (json['assists'] as num).toInt(),
      cards: Cards.fromJson(json['cards'] as Map<String, dynamic>),
      goals: (json['goals'] as num).toInt(),
      matches: (json['matches'] as num).toInt(),
    );

Map<String, dynamic> _$StatsToJson(Stats instance) => <String, dynamic>{
      'assists': instance.assists,
      'cards': instance.cards,
      'goals': instance.goals,
      'matches': instance.matches,
    };
