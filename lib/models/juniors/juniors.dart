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
  final int? startWeek;

  Junior({
    required this.id,
    required this.teamId,
    required this.name,
    required this.fullName,
    required this.skill,
    required this.age,
    required this.weeksLeft,
    required this.startWeek,
  });

  factory Junior.fromJson(Map<String, dynamic> json) => _$JuniorFromJson(json);
  Map<String, dynamic> toJson() => _$JuniorToJson(this);

  Junior copyWith({
    int? id,
    int? teamId,
    String? name,
    PlayerName? fullName,
    int? skill,
    int? age,
    int? weeksLeft,
    int? startWeek,
  }) {
    return Junior(
      id: id ?? this.id,
      teamId: teamId ?? this.teamId,
      name: name ?? this.name,
      fullName: fullName ?? this.fullName,
      skill: skill ?? this.skill,
      age: age ?? this.age,
      weeksLeft: weeksLeft ?? this.weeksLeft,
      startWeek: startWeek ?? this.startWeek,
    );
  }
}

@JsonSerializable()
class Juniors {
  final List<Junior>? juniors;
  final List<Junior>? prevJuniors;

  Juniors({required this.juniors, required this.prevJuniors});

  factory Juniors.fromJson(Map<String, dynamic> json) =>
      _$JuniorsFromJson(json);
  Map<String, dynamic> toJson() => _$JuniorsToJson(this);
}
