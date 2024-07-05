import 'package:json_annotation/json_annotation.dart';

part 'stats.g.dart';

@JsonSerializable()
class Stats {
  int cards;
  int yellow;
  int red;
  int goals;
  int assists;
  int matches;

  Stats({
    required this.cards,
    required this.yellow,
    required this.red,
    required this.goals,
    required this.assists,
    required this.matches,
  });

  factory Stats.fromJson(Map<String, dynamic> json) => _$StatsFromJson(json);

  Map<String, dynamic> toJson() => _$StatsToJson(this);
}
