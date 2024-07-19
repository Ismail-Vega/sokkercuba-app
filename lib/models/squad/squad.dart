import 'package:json_annotation/json_annotation.dart';

import '../player/player.dart';

part 'squad.g.dart';

@JsonSerializable()
class Squad {
  final List<TeamPlayer> players;
  final List<TeamPlayer>? prevPlayers;
  final int total;

  Squad({
    required this.players,
    required this.prevPlayers,
    required this.total,
  });

  factory Squad.fromJson(Map<String, dynamic> json) => _$SquadFromJson(json);
  Map<String, dynamic> toJson() => _$SquadToJson(this);
}
