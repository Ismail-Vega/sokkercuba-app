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
            int.parse(k), PlayerHistory.fromJson(e as Map<String, dynamic>)),
      ),
      isObserved: json['isObserved'] as bool?,
    );

Map<String, dynamic> _$TeamPlayerToJson(TeamPlayer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'info': instance.info,
      'transfer': instance.transfer,
      'isObserved': instance.isObserved,
      'skillsHistory':
          instance.skillsHistory?.map((k, e) => MapEntry(k.toString(), e)),
    };
