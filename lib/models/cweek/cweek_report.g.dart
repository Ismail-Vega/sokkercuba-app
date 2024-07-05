// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cweek_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CWeekReport _$CWeekReportFromJson(Map<String, dynamic> json) => CWeekReport(
      week: (json['week'] as num).toInt(),
      day: Day.fromJson(json['day'] as Map<String, dynamic>),
      skills: Skills.fromJson(json['skills'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CWeekReportToJson(CWeekReport instance) =>
    <String, dynamic>{
      'week': instance.week,
      'day': instance.day,
      'skills': instance.skills,
    };
