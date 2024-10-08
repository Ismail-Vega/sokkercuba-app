// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'skill_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SkillProgress _$SkillProgressFromJson(Map<String, dynamic> json) =>
    SkillProgress(
      stamina: SkillValue.fromJson(json['stamina'] as Map<String, dynamic>),
      keeper: SkillValue.fromJson(json['keeper'] as Map<String, dynamic>),
      playmaking:
          SkillValue.fromJson(json['playmaking'] as Map<String, dynamic>),
      passing: SkillValue.fromJson(json['passing'] as Map<String, dynamic>),
      technique: SkillValue.fromJson(json['technique'] as Map<String, dynamic>),
      defending: SkillValue.fromJson(json['defending'] as Map<String, dynamic>),
      striker: SkillValue.fromJson(json['striker'] as Map<String, dynamic>),
      pace: SkillValue.fromJson(json['pace'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SkillProgressToJson(SkillProgress instance) =>
    <String, dynamic>{
      'stamina': instance.stamina,
      'keeper': instance.keeper,
      'playmaking': instance.playmaking,
      'passing': instance.passing,
      'technique': instance.technique,
      'defending': instance.defending,
      'striker': instance.striker,
      'pace': instance.pace,
    };

SkillValue _$SkillValueFromJson(Map<String, dynamic> json) => SkillValue(
      current: (json['current'] as num).toDouble(),
      next: (json['next'] as num).toDouble(),
    );

Map<String, dynamic> _$SkillValueToJson(SkillValue instance) =>
    <String, dynamic>{
      'current': instance.current,
      'next': instance.next,
    };
