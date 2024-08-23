// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerHistory _$PlayerHistoryFromJson(Map<String, dynamic> json) =>
    PlayerHistory(
      info: json['info'] == null
          ? null
          : PlayerInfo.fromJson(json['info'] as Map<String, dynamic>),
      date: json['date'] as String?,
    );

Map<String, dynamic> _$PlayerHistoryToJson(PlayerHistory instance) =>
    <String, dynamic>{
      'info': instance.info,
      'date': instance.date,
    };
