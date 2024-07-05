// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_wage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Wage _$WageFromJson(Map<String, dynamic> json) => Wage(
      value: (json['value'] as num).toInt(),
      currency: json['currency'] as String,
    );

Map<String, dynamic> _$WageToJson(Wage instance) => <String, dynamic>{
      'value': instance.value,
      'currency': instance.currency,
    };
