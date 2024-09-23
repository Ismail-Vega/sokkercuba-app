import 'package:json_annotation/json_annotation.dart';

import 'player_history.dart';
import 'player_info.dart';

part 'player.g.dart';

@JsonSerializable()
class TeamPlayer {
  final int id;
  final PlayerInfo info;
  final dynamic transfer;
  bool? isObserved;
  Map<int, PlayerHistory>? skillsHistory;

  TeamPlayer({
    required this.id,
    required this.info,
    required this.transfer,
    this.skillsHistory,
    this.isObserved,
  }) {
    skillsHistory ??= {};
    isObserved ??= false;
  }

  factory TeamPlayer.fromJson(Map<String, dynamic> json) =>
      _$TeamPlayerFromJson(json);
  Map<String, dynamic> toJson() => _$TeamPlayerToJson(this);
}
