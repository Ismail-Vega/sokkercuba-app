import 'package:json_annotation/json_annotation.dart';

import '../player/player_info.dart';
import 'training_report.dart';

part 'training.g.dart';

@JsonSerializable()
class PlayerTrainingReport {
  final int id;
  final PlayerInfo player;
  final TrainingReport report;

  PlayerTrainingReport(
      {required this.id, required this.player, required this.report});

  factory PlayerTrainingReport.fromJson(Map<String, dynamic> json) =>
      _$PlayerTrainingReportFromJson(json);
  Map<String, dynamic> toJson() => _$PlayerTrainingReportToJson(this);
}

@JsonSerializable()
class SquadTraining {
  final List<PlayerTrainingReport> players;

  SquadTraining({required this.players});

  factory SquadTraining.fromJson(Map<String, dynamic> json) =>
      _$SquadTrainingFromJson(json);
  Map<String, dynamic> toJson() => _$SquadTrainingToJson(this);
}
