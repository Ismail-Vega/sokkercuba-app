// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cweek.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Player _$PlayerFromJson(Map<String, dynamic> json) => Player(
      id: (json['id'] as num).toInt(),
      player: PlayerInfo.fromJson(json['player'] as Map<String, dynamic>),
      report: CWeekReport.fromJson(json['report'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PlayerToJson(Player instance) => <String, dynamic>{
      'id': instance.id,
      'player': instance.player,
      'report': instance.report,
    };

CWeek _$CWeekFromJson(Map<String, dynamic> json) => CWeek(
      players: (json['players'] as List<dynamic>)
          .map((e) => Player.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CWeekToJson(CWeek instance) => <String, dynamic>{
      'players': instance.players,
    };
