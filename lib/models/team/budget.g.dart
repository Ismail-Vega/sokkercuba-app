// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Budget _$BudgetFromJson(Map<String, dynamic> json) => Budget(
      value: (json['value'] as num).toInt(),
      currency: json['currency'] as String,
    );

Map<String, dynamic> _$BudgetToJson(Budget instance) => <String, dynamic>{
      'value': instance.value,
      'currency': instance.currency,
    };
