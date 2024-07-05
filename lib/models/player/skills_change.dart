import 'package:json_annotation/json_annotation.dart';

part 'skills_change.g.dart';

@JsonSerializable()
class SkillsChange {
  int form;
  int tacticalDiscipline;
  int teamwork;
  int experience;
  int stamina;
  int keeper;
  int playmaking;
  int passing;
  int technique;
  int defending;
  int striker;
  int pace;
  int down;
  int up;

  SkillsChange({
    required this.form,
    required this.tacticalDiscipline,
    required this.teamwork,
    required this.experience,
    required this.stamina,
    required this.keeper,
    required this.playmaking,
    required this.passing,
    required this.technique,
    required this.defending,
    required this.striker,
    required this.pace,
    required this.down,
    required this.up,
  });

  factory SkillsChange.fromJson(Map<String, dynamic> json) =>
      _$SkillsChangeFromJson(json);

  Map<String, dynamic> toJson() => _$SkillsChangeToJson(this);
}
