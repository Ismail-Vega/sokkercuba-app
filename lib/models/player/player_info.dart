import 'package:json_annotation/json_annotation.dart';

import '../../mixins/skills_mixin.dart';
import '../common/code_name.dart';
import '../team/team.dart';
import 'characteristics.dart';
import 'face.dart';
import 'injury.dart';
import 'player_name.dart';
import 'player_value.dart';
import 'player_wage.dart';
import 'skill_progress.dart';
import 'skills.dart';
import 'skills_change.dart';
import 'stats.dart';

part 'player_info.g.dart';

@JsonSerializable()
class PlayerInfo with SkillMethods {
  final PlayerName name;
  final CodeName? formation;
  final int? number;
  final Team team;
  final CodeName country;
  final PlayerValue? value;
  final PlayerValue? previousValue;
  final Wage? wage;
  final Characteristics characteristics;
  @override
  final Skills skills;
  @override
  final SkillsChange? skillsChange;
  final Stats stats;
  final Stats nationalStats;
  final Face face;
  final int? youthTeamId;
  final Injury injury;
  final bool nationalSharing;
  final SkillProgress skillProgress;

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
    this.skillsChange,
    required this.stats,
    required this.nationalStats,
    required this.face,
    required this.youthTeamId,
    required this.injury,
    required this.nationalSharing,
    SkillProgress? skillProgress,
  }) : skillProgress = skillProgress ??
            SkillProgress(
              stamina: SkillValue(current: 0.0, next: 0.0),
              keeper: SkillValue(current: 0.0, next: 0.0),
              playmaking: SkillValue(current: 0.0, next: 0.0),
              passing: SkillValue(current: 0.0, next: 0.0),
              technique: SkillValue(current: 0.0, next: 0.0),
              defending: SkillValue(current: 0.0, next: 0.0),
              striker: SkillValue(current: 0.0, next: 0.0),
              pace: SkillValue(current: 0.0, next: 0.0),
            );

  PlayerInfo copyWith({
    Skills? skills,
    SkillsChange? skillsChange,
    SkillProgress? skillProgress,
  }) {
    return PlayerInfo(
      name: name,
      formation: formation,
      number: number,
      team: team,
      country: country,
      value: value,
      previousValue: previousValue,
      wage: wage,
      characteristics: characteristics,
      skills: skills ?? this.skills,
      skillsChange: skillsChange ?? this.skillsChange,
      stats: stats,
      nationalStats: nationalStats,
      face: face,
      youthTeamId: youthTeamId,
      injury: injury,
      nationalSharing: nationalSharing,
      skillProgress: skillProgress ?? this.skillProgress,
    );
  }

  factory PlayerInfo.fromJson(Map<String, dynamic> json) =>
      _$PlayerInfoFromJson(json);
  Map<String, dynamic> toJson() => _$PlayerInfoToJson(this);
}
