import 'package:json_annotation/json_annotation.dart';

import '../common/date_time.dart';
import '../common/day.dart';
import 'budget.dart';
import 'lock.dart';
import 'settings.dart';
import 'team.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final int id;
  final String name;
  final Team team;
  final Budget budget;
  final List<dynamic> roles;
  final bool plus;
  final bool hasTrialPlus;
  final dynamic plusDeadline;
  final Day today;
  final DateTime dateTime;
  final List<String> enabledFeatures;
  final String sl;
  final int nationalTeamId;
  final dynamic nationalTeam;
  final bool firstLogin;
  final Lock lock;
  final Settings settings;
  final bool? hasSubscription;
  final bool? subscriptionNextPayment;

  User(
    this.hasSubscription,
    this.subscriptionNextPayment, {
    required this.id,
    required this.name,
    required this.team,
    required this.budget,
    required this.roles,
    required this.plus,
    required this.hasTrialPlus,
    required this.plusDeadline,
    required this.today,
    required this.dateTime,
    required this.enabledFeatures,
    required this.sl,
    required this.nationalTeamId,
    required this.nationalTeam,
    required this.firstLogin,
    required this.lock,
    required this.settings,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
