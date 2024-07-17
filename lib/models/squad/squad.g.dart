// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'squad.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeamPlayer _$TeamPlayerFromJson(Map<String, dynamic> json) => TeamPlayer(
      id: (json['id'] as num).toInt(),
      info: PlayerInfo.fromJson(json['info'] as Map<String, dynamic>),
      transfer: json['transfer'],
    );

Map<String, dynamic> _$TeamPlayerToJson(TeamPlayer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'info': instance.info,
      'transfer': instance.transfer,
    };

Squad _$SquadFromJson(Map<String, dynamic> json) => Squad(
      players: (json['players'] as List<dynamic>?)
          ?.map((e) => TeamPlayer.fromJson(e as Map<String, dynamic>))
          .toList(),
      prevPlayers: (json['prevPlayers'] as List<dynamic>?)
          ?.map((e) => TeamPlayer.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SquadToJson(Squad instance) => <String, dynamic>{
      'players': instance.players,
      'prevPlayers': instance.prevPlayers,
      'total': instance.total,
    };
