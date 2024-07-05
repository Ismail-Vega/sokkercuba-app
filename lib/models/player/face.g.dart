// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'face.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Face _$FaceFromJson(Map<String, dynamic> json) => Face(
      face: (json['face'] as num).toInt(),
      skinColor: (json['skinColor'] as num).toInt(),
      hairColor: (json['hairColor'] as num).toInt(),
      hair: (json['hair'] as num).toInt(),
      eyes: (json['eyes'] as num).toInt(),
      nose: (json['nose'] as num).toInt(),
      beard: (json['beard'] as num).toInt(),
      beardColor: (json['beardColor'] as num).toInt(),
      shirt: (json['shirt'] as num).toInt(),
      mouth: (json['mouth'] as num).toInt(),
    );

Map<String, dynamic> _$FaceToJson(Face instance) => <String, dynamic>{
      'face': instance.face,
      'skinColor': instance.skinColor,
      'hairColor': instance.hairColor,
      'hair': instance.hair,
      'eyes': instance.eyes,
      'nose': instance.nose,
      'beard': instance.beard,
      'beardColor': instance.beardColor,
      'shirt': instance.shirt,
      'mouth': instance.mouth,
    };
