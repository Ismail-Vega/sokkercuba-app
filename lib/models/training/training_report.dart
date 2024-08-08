import 'package:json_annotation/json_annotation.dart';

import '../../mixins/skills_mixin.dart';
import '../common/code_name.dart';
import '../common/day.dart';
import '../player/injury.dart';
import '../player/player_value.dart';
import '../player/skills.dart';
import '../player/skills_change.dart';
import 'games.dart';

part 'training_report.g.dart';

@JsonSerializable()
class TrainingReport with SkillMethods {
  final int week;
  final Day day;
  @override
  final Skills skills;
  @override
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
}
