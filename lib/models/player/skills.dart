import 'package:json_annotation/json_annotation.dart';

part 'skills.g.dart';

@JsonSerializable()
class Skills {
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

  Skills({
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
  });

  factory Skills.fromJson(Map<String, dynamic> json) => _$SkillsFromJson(json);

  Map<String, dynamic> toJson() => _$SkillsToJson(this);
}
