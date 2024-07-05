// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'injury.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Injury _$InjuryFromJson(Map<String, dynamic> json) => Injury(
      daysRemaining: (json['daysRemaining'] as num).toInt(),
      severe: json['severe'] as bool,
    );

Map<String, dynamic> _$InjuryToJson(Injury instance) => <String, dynamic>{
      'daysRemaining': instance.daysRemaining,
      'severe': instance.severe,
    };
