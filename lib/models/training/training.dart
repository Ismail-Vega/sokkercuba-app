import 'package:json_annotation/json_annotation.dart';

import '../common/code_name.dart';
import '../common/day.dart';
import '../player/injury.dart';
import '../player/player_value.dart';
import '../player/skills.dart';
import '../player/skills_change.dart';
import 'games.dart';

part 'training.g.dart';

@JsonSerializable()
class Report {
  final int age;
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

  Report({
    required this.age,
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

  factory Report.fromJson(Map<String, dynamic> json) => _$ReportFromJson(json);
  Map<String, dynamic> toJson() => _$ReportToJson(this);
}

@JsonSerializable()
class Training {
  final int id;
  final List<Report> reports;

  Training({required this.id, required this.reports});

  factory Training.fromJson(Map<String, dynamic> json) =>
      _$TrainingFromJson(json);
  Map<String, dynamic> toJson() => _$TrainingToJson(this);
}
