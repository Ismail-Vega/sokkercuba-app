// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cards.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cards _$CardsFromJson(Map<String, dynamic> json) => Cards(
      cards: (json['cards'] as num).toInt(),
      yellow: (json['yellow'] as num).toInt(),
      red: (json['red'] as num).toInt(),
    );

Map<String, dynamic> _$CardsToJson(Cards instance) => <String, dynamic>{
      'cards': instance.cards,
      'yellow': instance.yellow,
      'red': instance.red,
    };
