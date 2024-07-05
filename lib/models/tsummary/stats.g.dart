// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Stats _$StatsFromJson(Map<String, dynamic> json) => Stats(
      general: (json['general'] as num).toInt(),
      advanced: (json['advanced'] as num).toInt(),
      skillsUp: (json['skillsUp'] as num).toInt(),
    );

Map<String, dynamic> _$StatsToJson(Stats instance) => <String, dynamic>{
      'general': instance.general,
      'advanced': instance.advanced,
      'skillsUp': instance.skillsUp,
    };
