// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'training.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Report _$ReportFromJson(Map<String, dynamic> json) => Report(
      age: (json['age'] as num).toInt(),
      week: (json['week'] as num).toInt(),
      day: Day.fromJson(json['day'] as Map<String, dynamic>),
      skills: Skills.fromJson(json['skills'] as Map<String, dynamic>),
      skillsChange:
          SkillsChange.fromJson(json['skillsChange'] as Map<String, dynamic>),
      type: CodeName.fromJson(json['type'] as Map<String, dynamic>),
      kind: CodeName.fromJson(json['kind'] as Map<String, dynamic>),
      playerValue:
          PlayerValue.fromJson(json['playerValue'] as Map<String, dynamic>),
      games: Games.fromJson(json['games'] as Map<String, dynamic>),
      intensity: (json['intensity'] as num).toInt(),
      formation: json['formation'] == null
          ? null
          : CodeName.fromJson(json['formation'] as Map<String, dynamic>),
      injury: Injury.fromJson(json['injury'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ReportToJson(Report instance) => <String, dynamic>{
      'age': instance.age,
      'week': instance.week,
      'day': instance.day,
      'skills': instance.skills,
      'skillsChange': instance.skillsChange,
      'type': instance.type,
      'kind': instance.kind,
      'playerValue': instance.playerValue,
      'games': instance.games,
      'intensity': instance.intensity,
      'formation': instance.formation,
      'injury': instance.injury,
    };

Training _$TrainingFromJson(Map<String, dynamic> json) => Training(
      id: (json['id'] as num).toInt(),
      reports: (json['reports'] as List<dynamic>)
          .map((e) => Report.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TrainingToJson(Training instance) => <String, dynamic>{
      'id': instance.id,
      'reports': instance.reports,
    };
