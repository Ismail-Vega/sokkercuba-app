import 'package:json_annotation/json_annotation.dart';

import '../player/player_name.dart';

part 'juniors.g.dart';

@JsonSerializable()
class Junior {
  final int id;
  final int teamId;
  final String name;
  final PlayerName fullName;
  final int skill;
  final int age;
  final int weeksLeft;

  Junior({
    required this.id,
    required this.teamId,
    required this.name,
    required this.fullName,
    required this.skill,
    required this.age,
    required this.weeksLeft,
  });

  factory Junior.fromJson(Map<String, dynamic> json) => _$JuniorFromJson(json);
  Map<String, dynamic> toJson() => _$JuniorToJson(this);
}

@JsonSerializable()
class Juniors {
  final List<Junior> juniors;

  Juniors({required this.juniors});

  factory Juniors.fromJson(Map<String, dynamic> json) =>
      _$JuniorsFromJson(json);
  Map<String, dynamic> toJson() => _$JuniorsToJson(this);
}
