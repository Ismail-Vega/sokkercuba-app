import 'dart:async';

import 'package:dio/dio.dart';

import '../models/juniors/juniors.dart';
import '../models/squad/squad.dart';
import '../models/team/team_stats.dart';
import '../models/team/user.dart';
import '../models/training/training.dart';
import '../models/tsummary/tsummary.dart';
import '../utils/constants.dart';
import 'api_client.dart';

Future<Map<String, dynamic>> fetchAllData(
    ApiClient apiClient, User user) async {
  try {
    final teamId = user.team.id;
    final plus = user.plus;

    final List<Future<dynamic>> initialPromises = [
      apiClient.fetchData(juniorsUrl),
      apiClient.fetchData(cweekUrl),
      apiClient.fetchData(tsummaryUrl),
      apiClient.fetchData(getTeamPlayersURL(teamId)),
      apiClient.fetchData(getTeamStatsURL(teamId))
    ];

    final responses = await Future.wait(initialPromises);
    final juniors = Juniors.fromJson(responses[0]);
    final cweek = SquadTraining.fromJson(responses[1]);
    final tsummary = TSummary.fromJson(responses[2]);
    final players = Squad.fromJson(responses[3]);
    final teamStats = UserStats.fromJson(responses[4]);

    if (!plus) {
      return {
        'juniors': juniors,
        'cweek': cweek,
        'tsummary': tsummary,
        'players': players,
        'training': cweekToTrainingData(cweek.players),
        'userStats': teamStats,
        'code': 200,
      };
    }

    final trainingReports = await getTrainingReports(apiClient, cweek.players);

    return {
      'juniors': juniors,
      'cweek': cweek,
      'tsummary': tsummary,
      'players': players,
      'training': trainingReports,
      'userStats': teamStats,
      'code': 200,
    };
  } catch (error) {
    return {'code': '500', 'error': error.toString()};
  }
}

Future<Object> getTrainingReports(ApiClient apiClient, dynamic players) async {
  if (players == null || players.length == 0) {
    return [];
  }

  final List<Future<Response>> fullReportPromises =
      players.map<Future<Response>>((player) {
    return apiClient.fetchData(getPlayerFullReportURL(player['id']));
  }).toList();

  final tResponse = await Future.wait(fullReportPromises);

  return tResponse.asMap().entries.map((entry) {
    final reports = entry.value.data['reports'];
    reports.removeLast();

    return {
      'id': players[entry.key]['id'],
      'player': players[entry.key]['player'],
      'reports': reports.toList(),
    };
  }).toList();
}

List<Map<String, dynamic>> cweekToTrainingData(dynamic players) {
  if (players == null || players.length == 0) return [];

  return players.map<Map<String, dynamic>>((item) {
    return {
      'id': item['id'],
      'player': item['player'],
      'reports': [item['report']]
    };
  }).toList();
}
