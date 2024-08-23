import 'package:json_annotation/json_annotation.dart';

import 'player_info.dart';

part 'player_history.g.dart';

@JsonSerializable()
class PlayerHistory {
  final PlayerInfo? info;
  final String? date;

  PlayerHistory({
    required this.info,
    required this.date,
  });

  factory PlayerHistory.fromJson(Map<String, dynamic> json) =>
      _$PlayerHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerHistoryToJson(this);
}
