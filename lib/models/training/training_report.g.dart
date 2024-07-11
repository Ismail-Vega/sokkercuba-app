// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'training_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrainingReport _$TrainingReportFromJson(Map<String, dynamic> json) =>
    TrainingReport(
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

Map<String, dynamic> _$TrainingReportToJson(TrainingReport instance) =>
    <String, dynamic>{
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
