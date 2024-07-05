// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'date_time.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DateTime _$DateTimeFromJson(Map<String, dynamic> json) => DateTime(
      date: json['date'] as String,
      timezoneType: (json['timezone_type'] as num).toInt(),
      timezone: json['timezone'] as String,
    );

Map<String, dynamic> _$DateTimeToJson(DateTime instance) => <String, dynamic>{
      'date': instance.date,
      'timezone_type': instance.timezoneType,
      'timezone': instance.timezone,
    };
