// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'skills.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Skills _$SkillsFromJson(Map<String, dynamic> json) => Skills(
      form: (json['form'] as num).toInt(),
      tacticalDiscipline: (json['tacticalDiscipline'] as num).toInt(),
      teamwork: (json['teamwork'] as num).toInt(),
      experience: (json['experience'] as num).toInt(),
      stamina: (json['stamina'] as num).toInt(),
      keeper: (json['keeper'] as num).toInt(),
      playmaking: (json['playmaking'] as num).toInt(),
      passing: (json['passing'] as num).toInt(),
      technique: (json['technique'] as num).toInt(),
      defending: (json['defending'] as num).toInt(),
      striker: (json['striker'] as num).toInt(),
      pace: (json['pace'] as num).toInt(),
    );

Map<String, dynamic> _$SkillsToJson(Skills instance) => <String, dynamic>{
      'form': instance.form,
      'tacticalDiscipline': instance.tacticalDiscipline,
      'teamwork': instance.teamwork,
      'experience': instance.experience,
      'stamina': instance.stamina,
      'keeper': instance.keeper,
      'playmaking': instance.playmaking,
      'passing': instance.passing,
      'technique': instance.technique,
      'defending': instance.defending,
      'striker': instance.striker,
      'pace': instance.pace,
    };
