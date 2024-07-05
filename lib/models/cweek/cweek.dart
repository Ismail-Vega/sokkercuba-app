import 'package:json_annotation/json_annotation.dart';

import '../player/player_info.dart';
import 'cweek_report.dart';

part 'cweek.g.dart';

@JsonSerializable()
class Player {
  final int id;
  final PlayerInfo player;
  final CWeekReport report;

  Player({required this.id, required this.player, required this.report});

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);
  Map<String, dynamic> toJson() => _$PlayerToJson(this);
}

@JsonSerializable()
class CWeek {
  final List<Player> players;

  CWeek({required this.players});

  factory CWeek.fromJson(Map<String, dynamic> json) => _$CWeekFromJson(json);
  Map<String, dynamic> toJson() => _$CWeekToJson(this);
}
