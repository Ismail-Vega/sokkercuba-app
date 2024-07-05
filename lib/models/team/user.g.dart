// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      team: Team.fromJson(json['team'] as Map<String, dynamic>),
      budget: Budget.fromJson(json['budget'] as Map<String, dynamic>),
      roles: json['roles'] as List<dynamic>,
      plus: json['plus'] as bool,
      hasTrialPlus: json['hasTrialPlus'] as bool,
      plusDeadline: json['plusDeadline'],
      today: Day.fromJson(json['today'] as Map<String, dynamic>),
      dateTime: DateTime.fromJson(json['dateTime'] as Map<String, dynamic>),
      enabledFeatures: (json['enabledFeatures'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      sl: json['sl'] as String,
      nationalTeamId: (json['nationalTeamId'] as num).toInt(),
      nationalTeam: json['nationalTeam'],
      firstLogin: json['firstLogin'] as bool,
      lock: Lock.fromJson(json['lock'] as Map<String, dynamic>),
      settings: Settings.fromJson(json['settings'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'team': instance.team,
      'budget': instance.budget,
      'roles': instance.roles,
      'plus': instance.plus,
      'hasTrialPlus': instance.hasTrialPlus,
      'plusDeadline': instance.plusDeadline,
      'today': instance.today,
      'dateTime': instance.dateTime,
      'enabledFeatures': instance.enabledFeatures,
      'sl': instance.sl,
      'nationalTeamId': instance.nationalTeamId,
      'nationalTeam': instance.nationalTeam,
      'firstLogin': instance.firstLogin,
      'lock': instance.lock,
      'settings': instance.settings,
    };
