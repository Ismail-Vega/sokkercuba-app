// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_value.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProgressValue _$ProgressValueFromJson(Map<String, dynamic> json) =>
    ProgressValue(
      x: (json['x'] as num).toInt(),
      y: (json['y'] as num).toInt(),
      scale: (json['scale'] as num).toInt(),
    );

Map<String, dynamic> _$ProgressValueToJson(ProgressValue instance) =>
    <String, dynamic>{
      'x': instance.x,
      'y': instance.y,
      'scale': instance.scale,
    };
