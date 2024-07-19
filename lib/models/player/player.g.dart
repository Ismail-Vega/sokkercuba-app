// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeamPlayer _$TeamPlayerFromJson(Map<String, dynamic> json) => TeamPlayer(
      id: (json['id'] as num).toInt(),
      info: PlayerInfo.fromJson(json['info'] as Map<String, dynamic>),
      transfer: json['transfer'],
      skillsHistory: (json['skillsHistory'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
            int.parse(k), PlayerInfo.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$TeamPlayerToJson(TeamPlayer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'info': instance.info,
      'transfer': instance.transfer,
      'skillsHistory':
          instance.skillsHistory?.map((k, e) => MapEntry(k.toString(), e)),
    };
