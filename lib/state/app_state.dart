import 'dart:ui';

import '../models/coach/trainer.dart';
import '../models/juniors/juniors.dart';
import '../models/juniors/juniors_training.dart';
import '../models/news/news.dart';
import '../models/player/player.dart';
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
  final int? trainingWeek;
  final bool loading;
  final bool transfersLoading;
  final bool loggedIn;
  final User? user;
  final News? news;
  final UserStats? userStats;
  final Juniors? juniors;
  final JuniorsTraining? juniorsTraining;
  final TSummary? tsummary;
  final Squad? players;
  final SquadTraining? training;
  final String? dataUpdatedOn;
  final Locale locale;
  final List<TeamPlayer> observedPlayers;
  final List<Trainer> trainers;

  AppState({
    this.error = false,
    this.errorMsg,
    this.username = '',
    this.teamId,
    this.trainingWeek,
    this.loading = false,
    this.transfersLoading = false,
    this.loggedIn = false,
    this.user,
    this.news,
    this.userStats,
    this.juniors,
    this.juniorsTraining,
    this.tsummary,
    this.players,
    this.training,
    this.dataUpdatedOn,
    this.locale = const Locale('en', 'us'),
    this.observedPlayers = const [],
    this.trainers = const [],
  });

  AppState copyWith(
      {bool? error,
      String? errorMsg,
      String? username,
      int? teamId,
      int? trainingWeek,
      bool? loading,
      bool? transfersLoading,
      bool? loggedIn,
      User? user,
      News? news,
      UserStats? userStats,
      Juniors? juniors,
      JuniorsTraining? juniorsTraining,
      TSummary? tsummary,
      Squad? players,
      SquadTraining? training,
      String? dataUpdatedOn,
      List<TeamPlayer>? observedPlayers,
      List<Trainer>? trainers,
      Locale? locale}) {
    return AppState(
      error: error ?? this.error,
      errorMsg: errorMsg ?? this.errorMsg,
      username: username ?? this.username,
      teamId: teamId ?? this.teamId,
      trainingWeek: trainingWeek ?? this.trainingWeek,
      loading: loading ?? this.loading,
      transfersLoading: transfersLoading ?? this.transfersLoading,
      loggedIn: loggedIn ?? this.loggedIn,
      user: user ?? this.user,
      news: news ?? this.news,
      userStats: userStats ?? this.userStats,
      tsummary: tsummary ?? this.tsummary,
      juniors: juniors ?? this.juniors,
      juniorsTraining: juniorsTraining ?? this.juniorsTraining,
      players: players ?? this.players,
      training: training ?? this.training,
      dataUpdatedOn: dataUpdatedOn ?? this.dataUpdatedOn,
      observedPlayers: observedPlayers ?? this.observedPlayers,
      trainers: trainers ?? this.trainers,
      locale: locale ?? this.locale,
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
      transfersLoading: payload['transfersLoading'] ?? transfersLoading,
      loggedIn: payload['loggedIn'] ?? loggedIn,
      user: payload['user'] ?? user,
      news: payload['news'] ?? news,
      userStats: payload['userStats'] ?? userStats,
      tsummary: payload['tsummary'] ?? tsummary,
      juniors: payload['juniors'] ?? juniors,
      juniorsTraining: payload['juniorsTraining'] ?? juniorsTraining,
      players: payload['players'] ?? players,
      training: payload['training'] ?? training,
      dataUpdatedOn: payload['dataUpdatedOn'] ?? dataUpdatedOn,
      locale: payload['locale'] ?? locale,
      observedPlayers: payload['observedPlayers'] ?? observedPlayers,
      trainers: payload['trainers'] ?? trainers,
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
      'transfersLoading': transfersLoading,
      'loggedIn': loggedIn,
      'user': user?.toJson(),
      'news': news?.toJson(),
      'userStats': userStats?.toJson(),
      'tsummary': tsummary?.toJson(),
      'juniors': juniors?.toJson(),
      'juniorsTraining': juniorsTraining?.toJson(),
      'players': players?.toJson(),
      'training': training?.toJson(),
      'dataUpdatedOn': dataUpdatedOn,
      'locale': {
        'languageCode': locale.languageCode,
        'countryCode': locale.countryCode,
      },
      'observedPlayers':
          observedPlayers.map((player) => player.toJson()).toList(),
      'trainers': trainers.map((trainer) => trainer.toJson()).toList(),
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
      transfersLoading: json['transfersLoading'] ?? false,
      loggedIn: json['loggedIn'] ?? false,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      news: json['news'] != null ? News.fromJson(json['news']) : null,
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
      dataUpdatedOn: json['dataUpdatedOn'],
      locale: json['locale'] != null
          ? Locale(
              json['locale']['languageCode'], json['locale']['countryCode'])
          : const Locale('en', 'US'),
      observedPlayers: (json['observedPlayers'] as List<dynamic>?)
              ?.map((e) => TeamPlayer.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      trainers: (json['trainers'] as List<dynamic>?)
              ?.map((e) => Trainer.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
