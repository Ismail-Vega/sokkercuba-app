import 'package:json_annotation/json_annotation.dart';

import '../common/date_value.dart';
import 'juniors_summary.dart';
import 'stats.dart';

part 'tsummary.g.dart';

@JsonSerializable()
class GameDay {
  final int season;
  final int week;
  final int seasonWeek;
  final int day;
  final DateValue date;

  GameDay({
    required this.season,
    required this.week,
    required this.seasonWeek,
    required this.day,
    required this.date,
  });

  factory GameDay.fromJson(Map<String, dynamic> json) =>
      _$GameDayFromJson(json);
  Map<String, dynamic> toJson() => _$GameDayToJson(this);
}

@JsonSerializable()
class Week {
  final GameDay gameDay;
  final int week;
  final Stats stats;
  final JuniorsSummary juniors;

  Week({
    required this.gameDay,
    required this.week,
    required this.stats,
    required this.juniors,
  });

  factory Week.fromJson(Map<String, dynamic> json) => _$WeekFromJson(json);
  Map<String, dynamic> toJson() => _$WeekToJson(this);
}

@JsonSerializable()
class TSummary {
  final List<Week> weeks;

  TSummary({required this.weeks});

  factory TSummary.fromJson(Map<String, dynamic> json) =>
      _$TSummaryFromJson(json);
  Map<String, dynamic> toJson() => _$TSummaryToJson(this);
}
