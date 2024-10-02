import 'package:json_annotation/json_annotation.dart';

part 'trainer.g.dart';

@JsonSerializable()
class Trainer {
  final int id;
  final int teamId;
  final TrainerInfo info;

  Trainer({
    required this.id,
    required this.teamId,
    required this.info,
  });

  factory Trainer.fromJson(Map<String, dynamic> json) =>
      _$TrainerFromJson(json);
  Map<String, dynamic> toJson() => _$TrainerToJson(this);
}

@JsonSerializable()
class TrainerInfo {
  final TrainerFullName fullName;
  final TrainerAssignment assignment;
  final TrainerSalary salary;
  final TrainerCountry country;
  final TrainerSkills skills;
  final String status;

  TrainerInfo({
    required this.fullName,
    required this.assignment,
    required this.salary,
    required this.country,
    required this.skills,
    required this.status,
  });

  factory TrainerInfo.fromJson(Map<String, dynamic> json) =>
      _$TrainerInfoFromJson(json);
  Map<String, dynamic> toJson() => _$TrainerInfoToJson(this);
}

@JsonSerializable()
class TrainerFullName {
  final String name;
  final String surname;
  final String full;

  TrainerFullName({
    required this.name,
    required this.surname,
    required this.full,
  });

  factory TrainerFullName.fromJson(Map<String, dynamic> json) =>
      _$TrainerFullNameFromJson(json);
  Map<String, dynamic> toJson() => _$TrainerFullNameToJson(this);
}

@JsonSerializable()
class TrainerAssignment {
  final int code;
  final String name;

  TrainerAssignment({
    required this.code,
    required this.name,
  });

  factory TrainerAssignment.fromJson(Map<String, dynamic> json) =>
      _$TrainerAssignmentFromJson(json);
  Map<String, dynamic> toJson() => _$TrainerAssignmentToJson(this);
}

@JsonSerializable()
class TrainerSalary {
  final int value;
  final String currency;

  TrainerSalary({
    required this.value,
    required this.currency,
  });

  factory TrainerSalary.fromJson(Map<String, dynamic> json) =>
      _$TrainerSalaryFromJson(json);
  Map<String, dynamic> toJson() => _$TrainerSalaryToJson(this);
}

@JsonSerializable()
class TrainerCountry {
  final int code;
  final String name;

  TrainerCountry({
    required this.code,
    required this.name,
  });

  factory TrainerCountry.fromJson(Map<String, dynamic> json) =>
      _$TrainerCountryFromJson(json);
  Map<String, dynamic> toJson() => _$TrainerCountryToJson(this);
}

@JsonSerializable()
class TrainerSkills {
  final TrainerSkill stamina;
  final TrainerSkill keeper;
  final TrainerSkill playmaking;
  final TrainerSkill passing;
  final TrainerSkill technique;
  final TrainerSkill defending;
  final TrainerSkill striker;
  final TrainerSkill pace;
  final int averagePercent;

  TrainerSkills({
    required this.stamina,
    required this.keeper,
    required this.playmaking,
    required this.passing,
    required this.technique,
    required this.defending,
    required this.striker,
    required this.pace,
    required this.averagePercent,
  });

  factory TrainerSkills.fromJson(Map<String, dynamic> json) =>
      _$TrainerSkillsFromJson(json);
  Map<String, dynamic> toJson() => _$TrainerSkillsToJson(this);
}

@JsonSerializable()
class TrainerSkill {
  final int value;
  final int percent;

  TrainerSkill({
    required this.value,
    required this.percent,
  });

  factory TrainerSkill.fromJson(Map<String, dynamic> json) =>
      _$TrainerSkillFromJson(json);
  Map<String, dynamic> toJson() => _$TrainerSkillToJson(this);
}
