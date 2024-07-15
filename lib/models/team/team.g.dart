// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Team _$TeamFromJson(Map<String, dynamic> json) => Team(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String?,
      rank: (json['rank'] as num?)?.toInt(),
      emblem: json['emblem'] as String?,
      country: json['country'] == null
          ? null
          : CodeName.fromJson(json['country'] as Map<String, dynamic>),
      colors: json['colors'] == null
          ? null
          : TeamColors.fromJson(json['colors'] as Map<String, dynamic>),
      nationalType: (json['nationalType'] as num?)?.toInt(),
      bankrupt: json['bankrupt'] as bool?,
    );

Map<String, dynamic> _$TeamToJson(Team instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'rank': instance.rank,
      'emblem': instance.emblem,
      'country': instance.country,
      'colors': instance.colors,
      'nationalType': instance.nationalType,
      'bankrupt': instance.bankrupt,
    };
