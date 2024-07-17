import 'package:json_annotation/json_annotation.dart';

import '../common/code_name.dart';
import '../common/day.dart';
import '../player/injury.dart';
import '../player/player_value.dart';
import '../player/skills.dart';
import '../player/skills_change.dart';
import 'games.dart';

part 'training_report.g.dart';

@JsonSerializable()
class TrainingReport {
  final int week;
  final Day day;
  final Skills skills;
  final SkillsChange skillsChange;
  final CodeName type;
  final CodeName kind;
  final PlayerValue playerValue;
  final Games games;
  final int intensity;
  final CodeName? formation;
  final Injury injury;

  TrainingReport({
    required this.week,
    required this.day,
    required this.skills,
    required this.skillsChange,
    required this.type,
    required this.kind,
    required this.playerValue,
    required this.games,
    required this.intensity,
    required this.formation,
    required this.injury,
  });

  factory TrainingReport.fromJson(Map<String, dynamic> json) =>
      _$TrainingReportFromJson(json);

  Map<String, dynamic> toJson() => _$TrainingReportToJson(this);

  int? getSkillChange(String skill) {
    switch (skill) {
      case 'form':
        return skillsChange.form;
      case 'tacticalDiscipline':
        return skillsChange.tacticalDiscipline;
      case 'teamwork':
        return skillsChange.teamwork;
      case 'experience':
        return skillsChange.experience;
      case 'stamina':
        return skillsChange.stamina;
      case 'keeper':
        return skillsChange.keeper;
      case 'playmaking':
        return skillsChange.playmaking;
      case 'passing':
        return skillsChange.passing;
      case 'technique':
        return skillsChange.technique;
      case 'defending':
        return skillsChange.defending;
      case 'striker':
        return skillsChange.striker;
      case 'pace':
        return skillsChange.pace;
      case 'down':
        return skillsChange.down;
      case 'up':
        return skillsChange.up;
      default:
        return null;
    }
  }
}
