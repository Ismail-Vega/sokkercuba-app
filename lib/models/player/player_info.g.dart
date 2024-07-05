// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerInfo _$PlayerInfoFromJson(Map<String, dynamic> json) => PlayerInfo(
      name: FullName.fromJson(json['name'] as Map<String, dynamic>),
      formation: json['formation'] == null
          ? null
          : CodeName.fromJson(json['formation'] as Map<String, dynamic>),
      number: json['number'],
      team: Team.fromJson(json['team'] as Map<String, dynamic>),
      country: CodeName.fromJson(json['country'] as Map<String, dynamic>),
      value: PlayerValue.fromJson(json['value'] as Map<String, dynamic>),
      previousValue: json['previousValue'],
      wage: Wage.fromJson(json['wage'] as Map<String, dynamic>),
      characteristics: Characteristics.fromJson(
          json['characteristics'] as Map<String, dynamic>),
      skills: Skills.fromJson(json['skills'] as Map<String, dynamic>),
      stats: Stats.fromJson(json['stats'] as Map<String, dynamic>),
      nationalStats:
          Stats.fromJson(json['nationalStats'] as Map<String, dynamic>),
      face: Face.fromJson(json['face'] as Map<String, dynamic>),
      youthTeamId: (json['youthTeamId'] as num).toInt(),
      injury: Injury.fromJson(json['injury'] as Map<String, dynamic>),
      nationalSharing: json['nationalSharing'] as bool,
    );

Map<String, dynamic> _$PlayerInfoToJson(PlayerInfo instance) =>
    <String, dynamic>{
      'name': instance.name,
      'formation': instance.formation,
      'number': instance.number,
      'team': instance.team,
      'country': instance.country,
      'value': instance.value,
      'previousValue': instance.previousValue,
      'wage': instance.wage,
      'characteristics': instance.characteristics,
      'skills': instance.skills,
      'stats': instance.stats,
      'nationalStats': instance.nationalStats,
      'face': instance.face,
      'youthTeamId': instance.youthTeamId,
      'injury': instance.injury,
      'nationalSharing': instance.nationalSharing,
    };
