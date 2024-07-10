// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserStats _$UserStatsFromJson(Map<String, dynamic> json) => UserStats(
      id: (json['id'] as num).toInt(),
      players: Players.fromJson(json['players'] as Map<String, dynamic>),
      reputation: (json['reputation'] as num).toInt(),
      rankChange:
          RankChange.fromJson(json['rankChange'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserStatsToJson(UserStats instance) => <String, dynamic>{
      'id': instance.id,
      'players': instance.players,
      'reputation': instance.reputation,
      'rankChange': instance.rankChange,
    };

Players _$PlayersFromJson(Map<String, dynamic> json) => Players(
      count: (json['count'] as num).toInt(),
      averageAge: (json['averageAge'] as num).toDouble(),
      averageForm: (json['averageForm'] as num).toInt(),
      averageFormSkill: (json['averageFormSkill'] as num).toInt(),
      totalValue: Value.fromJson(json['totalValue'] as Map<String, dynamic>),
      averageValue:
          Value.fromJson(json['averageValue'] as Map<String, dynamic>),
      averageMarks: (json['averageMarks'] as num).toInt(),
    );

Map<String, dynamic> _$PlayersToJson(Players instance) => <String, dynamic>{
      'count': instance.count,
      'averageAge': instance.averageAge,
      'averageForm': instance.averageForm,
      'averageFormSkill': instance.averageFormSkill,
      'totalValue': instance.totalValue,
      'averageValue': instance.averageValue,
      'averageMarks': instance.averageMarks,
    };

Value _$ValueFromJson(Map<String, dynamic> json) => Value(
      value: (json['value'] as num).toInt(),
      currency: json['currency'] as String,
    );

Map<String, dynamic> _$ValueToJson(Value instance) => <String, dynamic>{
      'value': instance.value,
      'currency': instance.currency,
    };

RankChange _$RankChangeFromJson(Map<String, dynamic> json) => RankChange(
      currentRank: (json['currentRank'] as num).toDouble(),
      previousRank: (json['previousRank'] as num).toDouble(),
    );

Map<String, dynamic> _$RankChangeToJson(RankChange instance) =>
    <String, dynamic>{
      'currentRank': instance.currentRank,
      'previousRank': instance.previousRank,
    };
