// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trainer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Trainer _$TrainerFromJson(Map<String, dynamic> json) => Trainer(
      id: (json['id'] as num).toInt(),
      teamId: (json['teamId'] as num).toInt(),
      info: TrainerInfo.fromJson(json['info'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TrainerToJson(Trainer instance) => <String, dynamic>{
      'id': instance.id,
      'teamId': instance.teamId,
      'info': instance.info,
    };

TrainerInfo _$TrainerInfoFromJson(Map<String, dynamic> json) => TrainerInfo(
      fullName:
          TrainerFullName.fromJson(json['fullName'] as Map<String, dynamic>),
      assignment: TrainerAssignment.fromJson(
          json['assignment'] as Map<String, dynamic>),
      salary: TrainerSalary.fromJson(json['salary'] as Map<String, dynamic>),
      country: TrainerCountry.fromJson(json['country'] as Map<String, dynamic>),
      skills: TrainerSkills.fromJson(json['skills'] as Map<String, dynamic>),
      status: json['status'] as String,
    );

Map<String, dynamic> _$TrainerInfoToJson(TrainerInfo instance) =>
    <String, dynamic>{
      'fullName': instance.fullName,
      'assignment': instance.assignment,
      'salary': instance.salary,
      'country': instance.country,
      'skills': instance.skills,
      'status': instance.status,
    };

TrainerFullName _$TrainerFullNameFromJson(Map<String, dynamic> json) =>
    TrainerFullName(
      name: json['name'] as String,
      surname: json['surname'] as String,
      full: json['full'] as String,
    );

Map<String, dynamic> _$TrainerFullNameToJson(TrainerFullName instance) =>
    <String, dynamic>{
      'name': instance.name,
      'surname': instance.surname,
      'full': instance.full,
    };

TrainerAssignment _$TrainerAssignmentFromJson(Map<String, dynamic> json) =>
    TrainerAssignment(
      code: (json['code'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$TrainerAssignmentToJson(TrainerAssignment instance) =>
    <String, dynamic>{
      'code': instance.code,
      'name': instance.name,
    };

TrainerSalary _$TrainerSalaryFromJson(Map<String, dynamic> json) =>
    TrainerSalary(
      value: (json['value'] as num).toInt(),
      currency: json['currency'] as String,
    );

Map<String, dynamic> _$TrainerSalaryToJson(TrainerSalary instance) =>
    <String, dynamic>{
      'value': instance.value,
      'currency': instance.currency,
    };

TrainerCountry _$TrainerCountryFromJson(Map<String, dynamic> json) =>
    TrainerCountry(
      code: (json['code'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$TrainerCountryToJson(TrainerCountry instance) =>
    <String, dynamic>{
      'code': instance.code,
      'name': instance.name,
    };

TrainerSkills _$TrainerSkillsFromJson(Map<String, dynamic> json) =>
    TrainerSkills(
      stamina: TrainerSkill.fromJson(json['stamina'] as Map<String, dynamic>),
      keeper: TrainerSkill.fromJson(json['keeper'] as Map<String, dynamic>),
      playmaking:
          TrainerSkill.fromJson(json['playmaking'] as Map<String, dynamic>),
      passing: TrainerSkill.fromJson(json['passing'] as Map<String, dynamic>),
      technique:
          TrainerSkill.fromJson(json['technique'] as Map<String, dynamic>),
      defending:
          TrainerSkill.fromJson(json['defending'] as Map<String, dynamic>),
      striker: TrainerSkill.fromJson(json['striker'] as Map<String, dynamic>),
      pace: TrainerSkill.fromJson(json['pace'] as Map<String, dynamic>),
      averagePercent: (json['averagePercent'] as num).toInt(),
    );

Map<String, dynamic> _$TrainerSkillsToJson(TrainerSkills instance) =>
    <String, dynamic>{
      'stamina': instance.stamina,
      'keeper': instance.keeper,
      'playmaking': instance.playmaking,
      'passing': instance.passing,
      'technique': instance.technique,
      'defending': instance.defending,
      'striker': instance.striker,
      'pace': instance.pace,
      'averagePercent': instance.averagePercent,
    };

TrainerSkill _$TrainerSkillFromJson(Map<String, dynamic> json) => TrainerSkill(
      value: (json['value'] as num).toInt(),
      percent: (json['percent'] as num).toInt(),
    );

Map<String, dynamic> _$TrainerSkillToJson(TrainerSkill instance) =>
    <String, dynamic>{
      'value': instance.value,
      'percent': instance.percent,
    };
