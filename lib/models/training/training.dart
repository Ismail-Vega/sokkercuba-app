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
  @JsonKey(
      fromJson: _playerTrainingReportMapFromJson,
      toJson: _playerTrainingReportMapToJson)
  final Map<String, PlayerTrainingReport> players;

  SquadTraining({required this.players});

  factory SquadTraining.fromJson(Map<String, dynamic> json) =>
      _$SquadTrainingFromJson(json);

  Map<String, dynamic> toJson() => _$SquadTrainingToJson(this);

  static Map<String, PlayerTrainingReport> _playerTrainingReportMapFromJson(
      Map<String, dynamic>? json) {
    if (json == null) {
      return {};
    }
    return json.map((key, value) => MapEntry(
        key, PlayerTrainingReport.fromJson(value as Map<String, dynamic>)));
  }

  static Map<String, dynamic> _playerTrainingReportMapToJson(
      Map<String, PlayerTrainingReport> map) {
    return map.map((key, value) => MapEntry(key, value.toJson()));
  }
}
