import 'package:json_annotation/json_annotation.dart';

import '../player/player_info.dart';
import 'training_report.dart';

part 'training_history.g.dart';

@JsonSerializable()
class PlayerTrainingHistory {
  final int id;
  final PlayerInfo player;
  final List<TrainingReport> reports;

  PlayerTrainingHistory(this.reports, this.id, this.player);

  factory PlayerTrainingHistory.fromJson(Map<String, dynamic> json) =>
      _$PlayerTrainingHistoryFromJson(json);
  Map<String, dynamic> toJson() => _$PlayerTrainingHistoryToJson(this);
}

@JsonSerializable()
class SquadTrainingHistory {
  final List<PlayerTrainingHistory> players;

  SquadTrainingHistory({required this.players});

  factory SquadTrainingHistory.fromJson(Map<String, dynamic> json) =>
      _$SquadTrainingHistoryFromJson(json);
  Map<String, dynamic> toJson() => _$SquadTrainingHistoryToJson(this);
}
