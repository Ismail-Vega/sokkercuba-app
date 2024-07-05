// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'color.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Color _$ColorFromJson(Map<String, dynamic> json) => Color(
      shirt: Shirt.fromJson(json['shirt'] as Map<String, dynamic>),
      trousers: Trousers.fromJson(json['trousers'] as Map<String, dynamic>),
      type: CodeName.fromJson(json['type'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ColorToJson(Color instance) => <String, dynamic>{
      'shirt': instance.shirt,
      'trousers': instance.trousers,
      'type': instance.type,
    };
