// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'training_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerTrainingHistory _$PlayerTrainingHistoryFromJson(
        Map<String, dynamic> json) =>
    PlayerTrainingHistory(
      (json['reports'] as List<dynamic>)
          .map((e) => TrainingReport.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['id'] as num).toInt(),
      PlayerInfo.fromJson(json['player'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PlayerTrainingHistoryToJson(
        PlayerTrainingHistory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'player': instance.player,
      'reports': instance.reports,
    };

SquadTrainingHistory _$SquadTrainingHistoryFromJson(
        Map<String, dynamic> json) =>
    SquadTrainingHistory(
      players: (json['players'] as List<dynamic>)
          .map((e) => PlayerTrainingHistory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SquadTrainingHistoryToJson(
        SquadTrainingHistory instance) =>
    <String, dynamic>{
      'players': instance.players,
    };
