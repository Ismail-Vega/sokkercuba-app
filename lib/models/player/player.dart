import 'package:json_annotation/json_annotation.dart';

import 'player_info.dart';

part 'player.g.dart';

@JsonSerializable()
class TeamPlayer {
  final int id;
  final PlayerInfo info;
  final dynamic transfer;
  final Map<int, PlayerInfo>? skillsHistory;

  TeamPlayer({
    required this.id,
    required this.info,
    required this.transfer,
    Map<int, PlayerInfo>? skillsHistory,
  }) : skillsHistory = skillsHistory ?? {};

  factory TeamPlayer.fromJson(Map<String, dynamic> json) =>
      _$TeamPlayerFromJson(json);
  Map<String, dynamic> toJson() => _$TeamPlayerToJson(this);
}
