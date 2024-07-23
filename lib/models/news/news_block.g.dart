// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsBlock _$NewsBlockFromJson(Map<String, dynamic> json) => NewsBlock(
      type: json['type'] as String,
      data: BlockData.fromJson(json['data'] as Map<String, dynamic>),
      actions: json['actions'] as List<dynamic>,
    );

Map<String, dynamic> _$NewsBlockToJson(NewsBlock instance) => <String, dynamic>{
      'type': instance.type,
      'data': instance.data,
      'actions': instance.actions,
    };

BlockData _$BlockDataFromJson(Map<String, dynamic> json) => BlockData(
      parts: (json['parts'] as List<dynamic>)
          .map((e) => Part.fromJson(e as Map<String, dynamic>))
          .toList(),
      juniors: (json['juniors'] as List<dynamic>)
          .map((e) => NewsJunior.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BlockDataToJson(BlockData instance) => <String, dynamic>{
      'parts': instance.parts,
      'juniors': instance.juniors,
    };

Part _$PartFromJson(Map<String, dynamic> json) => Part(
      key: json['key'] as String,
      properties: json['properties'],
    );

Map<String, dynamic> _$PartToJson(Part instance) => <String, dynamic>{
      'key': instance.key,
      'properties': instance.properties,
    };
