// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'juniors.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Junior _$JuniorFromJson(Map<String, dynamic> json) => Junior(
      id: (json['id'] as num).toInt(),
      teamId: (json['teamId'] as num).toInt(),
      name: json['name'] as String,
      fullName: PlayerName.fromJson(json['fullName'] as Map<String, dynamic>),
      skill: (json['skill'] as num).toInt(),
      age: (json['age'] as num).toInt(),
      weeksLeft: (json['weeksLeft'] as num).toInt(),
    );

Map<String, dynamic> _$JuniorToJson(Junior instance) => <String, dynamic>{
      'id': instance.id,
      'teamId': instance.teamId,
      'name': instance.name,
      'fullName': instance.fullName,
      'skill': instance.skill,
      'age': instance.age,
      'weeksLeft': instance.weeksLeft,
    };

Juniors _$JuniorsFromJson(Map<String, dynamic> json) => Juniors(
      juniors: (json['juniors'] as List<dynamic>?)
          ?.map((e) => Junior.fromJson(e as Map<String, dynamic>))
          .toList(),
      prevJuniors: (json['prevJuniors'] as List<dynamic>?)
          ?.map((e) => Junior.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$JuniorsToJson(Juniors instance) => <String, dynamic>{
      'juniors': instance.juniors,
      'prevJuniors': instance.prevJuniors,
    };
