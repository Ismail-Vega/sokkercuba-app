import 'package:json_annotation/json_annotation.dart';

import '../common/code_name.dart';
import '../team/team.dart';
import 'characteristics.dart';
import 'face.dart';
import 'full_name.dart';
import 'injury.dart';
import 'player_value.dart';
import 'player_wage.dart';
import 'skills.dart';
import 'stats.dart';

part 'player_info.g.dart';

@JsonSerializable()
class PlayerInfo {
  final FullName name;
  final CodeName? formation;
  final dynamic number;
  final Team team;
  final CodeName country;
  final PlayerValue value;
  final dynamic previousValue;
  final Wage wage;
  final Characteristics characteristics;
  final Skills skills;
  final Stats stats;
  final Stats nationalStats;
  final Face face;
  final int youthTeamId;
  final Injury injury;
  final bool nationalSharing;

  PlayerInfo({
    required this.name,
    required this.formation,
    required this.number,
    required this.team,
    required this.country,
    required this.value,
    required this.previousValue,
    required this.wage,
    required this.characteristics,
    required this.skills,
    required this.stats,
    required this.nationalStats,
    required this.face,
    required this.youthTeamId,
    required this.injury,
    required this.nationalSharing,
  });

  factory PlayerInfo.fromJson(Map<String, dynamic> json) =>
      _$PlayerInfoFromJson(json);
  Map<String, dynamic> toJson() => _$PlayerInfoToJson(this);
}
