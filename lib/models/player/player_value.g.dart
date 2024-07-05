// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_value.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerValue _$PlayerValueFromJson(Map<String, dynamic> json) => PlayerValue(
      value: (json['value'] as num).toInt(),
      currency: json['currency'] as String,
    );

Map<String, dynamic> _$PlayerValueToJson(PlayerValue instance) =>
    <String, dynamic>{
      'value': instance.value,
      'currency': instance.currency,
    };
