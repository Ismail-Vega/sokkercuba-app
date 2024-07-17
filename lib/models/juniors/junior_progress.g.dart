// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'junior_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JuniorProgress _$JuniorProgressFromJson(Map<String, dynamic> json) =>
    JuniorProgress(
      juniorId: (json['juniorId'] as num).toInt(),
      values: (json['values'] as List<dynamic>)
          .map((e) => ProgressValue.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$JuniorProgressToJson(JuniorProgress instance) =>
    <String, dynamic>{
      'juniorId': instance.juniorId,
      'values': instance.values,
    };
