import 'package:json_annotation/json_annotation.dart';

import 'cards.dart';

part 'stats.g.dart';

@JsonSerializable()
class Stats {
  int assists;
  Cards cards;
  int goals;
  int matches;

  Stats({
    required this.assists,
    required this.cards,
    required this.goals,
    required this.matches,
  });

  factory Stats.fromJson(Map<String, dynamic> json) => _$StatsFromJson(json);

  Map<String, dynamic> toJson() => _$StatsToJson(this);
}
