import 'package:json_annotation/json_annotation.dart';

import '../player/player_info.dart';

part 'squad.g.dart';

@JsonSerializable()
class TeamPlayer {
  final int id;
  final PlayerInfo info;
  final dynamic transfer;

  TeamPlayer({
    required this.id,
    required this.info,
    required this.transfer,
  });

  factory TeamPlayer.fromJson(Map<String, dynamic> json) =>
      _$TeamPlayerFromJson(json);
  Map<String, dynamic> toJson() => _$TeamPlayerToJson(this);
}

@JsonSerializable()
class Squad {
  final List<TeamPlayer>? players;
  final List<TeamPlayer>? prevPlayers;
  final int? total;

  Squad({
    required this.players,
    required this.prevPlayers,
    required this.total,
  });

  factory Squad.fromJson(Map<String, dynamic> json) => _$SquadFromJson(json);
  Map<String, dynamic> toJson() => _$SquadToJson(this);
}
