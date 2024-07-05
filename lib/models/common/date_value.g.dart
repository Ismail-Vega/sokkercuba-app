// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'date_value.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DateValue _$DateValueFromJson(Map<String, dynamic> json) => DateValue(
      value: json['value'] as String,
      timestamp: (json['timestamp'] as num).toInt(),
    );

Map<String, dynamic> _$DateValueToJson(DateValue instance) => <String, dynamic>{
      'value': instance.value,
      'timestamp': instance.timestamp,
    };
