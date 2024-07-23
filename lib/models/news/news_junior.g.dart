// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_junior.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsJunior _$NewsJuniorFromJson(Map<String, dynamic> json) => NewsJunior(
      id: (json['id'] as num).toInt(),
      fullName: json['fullName'] as String,
      position: json['position'] as String,
      age: (json['age'] as num).toInt(),
      weeks: (json['weeks'] as num).toInt(),
      total: (json['total'] as num).toInt(),
      potential: (json['potential'] as num).toInt(),
      potentialMin: (json['potentialMin'] as num).toInt(),
      potentialMax: (json['potentialMax'] as num).toInt(),
      active: json['active'] as bool,
      actions: json['actions'] as List<dynamic>,
    );

Map<String, dynamic> _$NewsJuniorToJson(NewsJunior instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'position': instance.position,
      'age': instance.age,
      'weeks': instance.weeks,
      'total': instance.total,
      'potential': instance.potential,
      'potentialMin': instance.potentialMin,
      'potentialMax': instance.potentialMax,
      'active': instance.active,
      'actions': instance.actions,
    };
