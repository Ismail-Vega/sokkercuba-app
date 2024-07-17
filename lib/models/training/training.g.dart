// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'training.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerTrainingReport _$PlayerTrainingReportFromJson(
        Map<String, dynamic> json) =>
    PlayerTrainingReport(
      id: (json['id'] as num).toInt(),
      player: PlayerInfo.fromJson(json['player'] as Map<String, dynamic>),
      report: TrainingReport.fromJson(json['report'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PlayerTrainingReportToJson(
        PlayerTrainingReport instance) =>
    <String, dynamic>{
      'id': instance.id,
      'player': instance.player,
      'report': instance.report,
    };

SquadTraining _$SquadTrainingFromJson(Map<String, dynamic> json) =>
    SquadTraining(
      players: SquadTraining._playerTrainingReportMapFromJson(
          json['players'] as Map<String, dynamic>?),
    );

Map<String, dynamic> _$SquadTrainingToJson(SquadTraining instance) =>
    <String, dynamic>{
      'players': SquadTraining._playerTrainingReportMapToJson(instance.players),
    };
