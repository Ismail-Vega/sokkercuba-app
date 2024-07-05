// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_colors.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeamColors _$TeamColorsFromJson(Map<String, dynamic> json) => TeamColors(
      first: Color.fromJson(json['first'] as Map<String, dynamic>),
      second: Color.fromJson(json['second'] as Map<String, dynamic>),
      keeper: Color.fromJson(json['keeper'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TeamColorsToJson(TeamColors instance) =>
    <String, dynamic>{
      'first': instance.first,
      'second': instance.second,
      'keeper': instance.keeper,
    };
