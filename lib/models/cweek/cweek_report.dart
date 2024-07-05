import 'package:json_annotation/json_annotation.dart';

import '../common/day.dart';
import '../player/skills.dart';

part 'cweek_report.g.dart';

@JsonSerializable()
class CWeekReport {
  int week;
  Day day;
  Skills skills;

  CWeekReport({
    required this.week,
    required this.day,
    required this.skills,
  });

  factory CWeekReport.fromJson(Map<String, dynamic> json) =>
      _$CWeekReportFromJson(json);

  Map<String, dynamic> toJson() => _$CWeekReportToJson(this);
}
