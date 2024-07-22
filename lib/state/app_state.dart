import '../models/juniors/juniors.dart';
import '../models/juniors/juniors_training.dart';
import '../models/squad/squad.dart';
import '../models/team/team_stats.dart';
import '../models/team/user.dart';
import '../models/training/training.dart';
import '../models/tsummary/tsummary.dart';
import 'actions.dart';

class AppState {
  final bool error;
  final String? errorMsg;
  final String username;
  final int? teamId;
  final int? trainingWeek;
  final bool loading;
  final bool loggedIn;
  final User? user;
  final UserStats? userStats;
  final Juniors? juniors;
  final JuniorsTraining? juniorsTraining;
  final TSummary? tsummary;
  final Squad? players;
  final SquadTraining? training;

  AppState({
    this.error = false,
    this.errorMsg,
    this.username = '',
    this.teamId,
    this.trainingWeek,
    this.loading = false,
    this.loggedIn = false,
    this.user,
    this.userStats,
    this.juniors,
    this.juniorsTraining,
    this.tsummary,
    this.players,
    this.training,
  });

  AppState copyWith({
    bool? error,
    String? errorMsg,
    String? username,
    int? teamId,
    int? trainingWeek,
    bool? loading,
    bool? loggedIn,
    User? user,
    UserStats? userStats,
    Juniors? juniors,
    JuniorsTraining? juniorsTraining,
    TSummary? tsummary,
    Squad? players,
    SquadTraining? training,
  }) {
    return AppState(
      error: error ?? this.error,
      errorMsg: errorMsg ?? this.errorMsg,
      username: username ?? this.username,
      teamId: teamId ?? this.teamId,
      trainingWeek: trainingWeek ?? this.trainingWeek,
      loading: loading ?? this.loading,
      loggedIn: loggedIn ?? this.loggedIn,
      user: user ?? this.user,
      userStats: userStats ?? this.userStats,
      tsummary: tsummary ?? this.tsummary,
      juniors: juniors ?? this.juniors,
      juniorsTraining: juniorsTraining ?? this.juniorsTraining,
      players: players ?? this.players,
      training: training ?? this.training,
    );
  }

  AppState copyWithAll(Map<String, dynamic> payload) {
    return AppState(
      error: payload['error'] ?? error,
      errorMsg: payload['errorMsg'] ?? errorMsg,
      username: payload['username'] ?? username,
      teamId: payload['teamId'] ?? teamId,
      trainingWeek: payload['trainingWeek'] ?? trainingWeek,
      loading: payload['loading'] ?? loading,
      loggedIn: payload['loggedIn'] ?? loggedIn,
      user: payload['user'] ?? user,
      userStats: payload['userStats'] ?? userStats,
      tsummary: payload['tsummary'] ?? tsummary,
      juniors: setJuniorsData(juniors, payload['juniors']),
      juniorsTraining: payload['juniorsTraining'] ?? juniorsTraining,
      players: setSquadData(players, payload['players']),
      training: payload['training'] ?? training,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'errorMsg': errorMsg,
      'username': username,
      'teamId': teamId,
      'trainingWeek': trainingWeek,
      'loading': loading,
      'loggedIn': loggedIn,
      'user': user?.toJson(),
      'userStats': userStats?.toJson(),
      'tsummary': tsummary?.toJson(),
      'juniors': juniors?.toJson(),
      'juniorsTraining': juniorsTraining?.toJson(),
      'players': players?.toJson(),
      'training': training?.toJson(),
    };
  }

  factory AppState.fromJson(Map<String, dynamic> json) {
    return AppState(
      error: json['error'] ?? false,
      errorMsg: json['errorMsg'],
      username: json['username'] ?? '',
      teamId: json['teamId'],
      trainingWeek: json['trainingWeek'],
      loading: json['loading'] ?? false,
      loggedIn: json['loggedIn'] ?? false,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      userStats: json['userStats'] != null
          ? UserStats.fromJson(json['userStats'])
          : null,
      juniors:
          json['juniors'] != null ? Juniors.fromJson(json['juniors']) : null,
      juniorsTraining: json['juniorsTraining'] != null
          ? JuniorsTraining.fromJson(json['juniorsTraining'])
          : null,
      tsummary:
          json['tsummary'] != null ? TSummary.fromJson(json['tsummary']) : null,
      players: json['players'] != null ? Squad.fromJson(json['players']) : null,
      training: json['training'] != null
          ? SquadTraining.fromJson(json['training'])
          : null,
    );
  }
}
