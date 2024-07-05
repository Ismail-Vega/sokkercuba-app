// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'games.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Games _$GamesFromJson(Map<String, dynamic> json) => Games(
      minutesOfficial: (json['minutesOfficial'] as num).toInt(),
      minutesFriendly: (json['minutesFriendly'] as num).toInt(),
      minutesNational: (json['minutesNational'] as num).toInt(),
    );

Map<String, dynamic> _$GamesToJson(Games instance) => <String, dynamic>{
      'minutesOfficial': instance.minutesOfficial,
      'minutesFriendly': instance.minutesFriendly,
      'minutesNational': instance.minutesNational,
    };
