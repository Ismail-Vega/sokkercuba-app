// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'characteristics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Characteristics _$CharacteristicsFromJson(Map<String, dynamic> json) =>
    Characteristics(
      age: (json['age'] as num).toInt(),
      height: (json['height'] as num).toInt(),
      weight: (json['weight'] as num).toInt(),
      bmi: (json['bmi'] as num).toDouble(),
    );

Map<String, dynamic> _$CharacteristicsToJson(Characteristics instance) =>
    <String, dynamic>{
      'age': instance.age,
      'height': instance.height,
      'weight': instance.weight,
      'bmi': instance.bmi,
    };
