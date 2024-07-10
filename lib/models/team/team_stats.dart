import 'package:json_annotation/json_annotation.dart';

part 'team_stats.g.dart';

@JsonSerializable()
class UserStats {
  final int id;
  final Players players;
  final int reputation;
  final RankChange rankChange;

  UserStats({
    required this.id,
    required this.players,
    required this.reputation,
    required this.rankChange,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) =>
      _$UserStatsFromJson(json);
  Map<String, dynamic> toJson() => _$UserStatsToJson(this);
}

@JsonSerializable()
class Players {
  final int count;
  final double averageAge;
  final int averageForm;
  final int averageFormSkill;
  final Value totalValue;
  final Value averageValue;
  final int averageMarks;

  Players({
    required this.count,
    required this.averageAge,
    required this.averageForm,
    required this.averageFormSkill,
    required this.totalValue,
    required this.averageValue,
    required this.averageMarks,
  });

  factory Players.fromJson(Map<String, dynamic> json) =>
      _$PlayersFromJson(json);
  Map<String, dynamic> toJson() => _$PlayersToJson(this);
}

@JsonSerializable()
class Value {
  final int value;
  final String currency;

  Value({
    required this.value,
    required this.currency,
  });

  factory Value.fromJson(Map<String, dynamic> json) => _$ValueFromJson(json);
  Map<String, dynamic> toJson() => _$ValueToJson(this);
}

@JsonSerializable()
class RankChange {
  final double currentRank;
  final double previousRank;

  RankChange({
    required this.currentRank,
    required this.previousRank,
  });

  factory RankChange.fromJson(Map<String, dynamic> json) =>
      _$RankChangeFromJson(json);
  Map<String, dynamic> toJson() => _$RankChangeToJson(this);
}
