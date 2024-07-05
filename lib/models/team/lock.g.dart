// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lock.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Lock _$LockFromJson(Map<String, dynamic> json) => Lock(
      transfersLocked: json['transfersLocked'] as bool,
      readOnlyMode: json['readOnlyMode'] as bool,
    );

Map<String, dynamic> _$LockToJson(Lock instance) => <String, dynamic>{
      'transfersLocked': instance.transfersLocked,
      'readOnlyMode': instance.readOnlyMode,
    };
