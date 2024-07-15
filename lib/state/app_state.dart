import '../models/juniors/juniors.dart';
import '../models/squad/squad.dart';
import '../models/team/team_stats.dart';
import '../models/team/user.dart';
import '../models/training/training.dart';
import '../models/tsummary/tsummary.dart';

class AppState {
  final bool error;
  final String? errorMsg;
  final String username;
  final int? teamId;
  final bool loading;
  final bool loggedIn;
  final User? user;
  final UserStats? userStats;
  final Juniors? juniors;
  final TSummary? tsummary;
  final Squad? players;
  final SquadTraining? training;

  AppState({
    this.error = false,
    this.errorMsg,
    this.username = '',
    this.teamId,
    this.loading = false,
    this.loggedIn = false,
    this.user,
    this.userStats,
    this.juniors,
    this.tsummary,
    this.players,
    this.training,
  });

  AppState copyWith({
    bool? error,
    String? errorMsg,
    String? username,
    int? teamId,
    bool? loading,
    bool? loggedIn,
    User? user,
    UserStats? userStats,
    Juniors? juniors,
    TSummary? tsummary,
    Squad? players,
    SquadTraining? training,
  }) {
    return AppState(
      error: error ?? this.error,
      errorMsg: errorMsg ?? this.errorMsg,
      username: username ?? this.username,
      teamId: teamId ?? this.teamId,
      loading: loading ?? this.loading,
      loggedIn: loggedIn ?? this.loggedIn,
      user: user ?? this.user,
      userStats: userStats ?? this.userStats,
      tsummary: tsummary ?? this.tsummary,
      juniors: Juniors(
        juniors: [
          ...(this.juniors?.juniors ?? []),
          ...(juniors?.juniors ?? []),
        ],
      ),
      players: Squad(players: [
        ...(this.players?.players ?? []),
        ...(players?.players ?? []),
      ], total: players?.total ?? this.players?.total ?? 0),
      training: SquadTraining(
        players: [
          ...(this.training?.players ?? []),
          ...(training?.players ?? []),
        ],
      ),
    );
  }

  AppState copyWithAll(Map<String, dynamic> payload) {
    return AppState(
      error: payload['error'] ?? error,
      errorMsg: payload['errorMsg'] ?? errorMsg,
      username: payload['username'] ?? username,
      teamId: payload['teamId'] ?? teamId,
      loading: payload['loading'] ?? loading,
      loggedIn: payload['loggedIn'] ?? loggedIn,
      user: payload['user'] ?? user,
      userStats: payload['userStats'] ?? userStats,
      tsummary: payload['tsummary'] ?? tsummary,
      juniors: Juniors(
        juniors: [
          ...(juniors?.juniors ?? []),
          ...(payload['juniors']?['juniors'] ?? []),
        ],
      ),
      players: Squad(players: [
        ...(players?.players ?? []),
        ...(payload['players']?['players'] ?? []),
      ], total: payload['training']['total'] ?? players?.total),
      training: SquadTraining(
        players: [
          ...(training?.players ?? []),
          ...(payload['training']?['players'] ?? []),
        ],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'errorMsg': errorMsg,
      'username': username,
      'teamId': teamId,
      'loading': loading,
      'loggedIn': loggedIn,
      'user': user?.toJson(),
      'userStats': userStats?.toJson(),
      'tsummary': tsummary?.toJson(),
      'juniors': juniors?.toJson(),
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
      loading: json['loading'] ?? false,
      loggedIn: json['loggedIn'] ?? false,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      userStats: json['userStats'] != null
          ? UserStats.fromJson(json['userStats'])
          : null,
      juniors:
          json['juniors'] != null ? Juniors.fromJson(json['juniors']) : null,
      tsummary:
          json['tsummary'] != null ? TSummary.fromJson(json['tsummary']) : null,
      players: json['players'] != null ? Squad.fromJson(json['players']) : null,
      training: json['training'] != null
          ? SquadTraining.fromJson(json['training'])
          : null,
    );
  }
}

class StoreAction {
  final StoreActionTypes type;
  final dynamic payload;
  final bool notify;

  StoreAction(this.type, this.payload, {this.notify = true});
}

enum StoreActionTypes {
  setError,
  setErrorMsg,
  setUsername,
  setTeamId,
  setLoading,
  setLogin,
  setUser,
  setUserStats,
  setJuniors,
  setSummary,
  setTeam,
  setTraining,
  setAll,
}
