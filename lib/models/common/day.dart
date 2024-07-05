import 'package:json_annotation/json_annotation.dart';

import 'date_value.dart';

part 'day.g.dart';

@JsonSerializable()
class Day {
  int season;
  int week;
  int seasonWeek;
  int day;
  DateValue date;

  Day({
    required this.season,
    required this.week,
    required this.seasonWeek,
    required this.day,
    required this.date,
  });

  factory Day.fromJson(Map<String, dynamic> json) => _$DayFromJson(json);

  Map<String, dynamic> toJson() => _$DayToJson(this);
}
