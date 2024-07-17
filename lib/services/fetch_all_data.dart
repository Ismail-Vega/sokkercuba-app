import 'dart:async';

import '../models/team/user.dart';
import '../models/training/training.dart';
import '../state/actions.dart';
import '../utils/constants.dart';
import 'api_client.dart';

Future<Map<String, dynamic>> fetchAllData(
    ApiClient apiClient, User user) async {
  try {
    final teamId = user.team.id;
    final plus = user.plus;

    final List<Future<dynamic>> initialPromises = [
      apiClient.fetchData(juniorsUrl),
      apiClient.fetchData(trainingUrl),
      apiClient.fetchData(tsummaryUrl),
      apiClient.fetchData(getTeamPlayersURL(teamId)),
      apiClient.fetchData(getTeamStatsURL(teamId))
    ];

    final responses = await Future.wait(initialPromises);
    final juniors = responses[0];
    final training = responses[1];
    final tsummary = responses[2];
    final playersData = responses[3];
    final teamStats = responses[4];

    if (!plus) {
      final trainingPlayers = training['players'] ?? [];
      Map<String, PlayerTrainingReport> players = {};

      if (trainingPlayers != null && trainingPlayers.isEmpty) {
        for (var player in trainingPlayers) {
          String key = '${player.id}_${player.report.week}';
          players[key] = player;
        }
      }

      return {
        'juniors': juniors,
        'tsummary': tsummary,
        'players': playersData,
        'training': SquadTraining(players: players),
        'userStats': teamStats,
        'code': 200,
      };
    }

    final filledTrainingReports =
        await fillTrainingReports(apiClient, training);

    return {
      'juniors': juniors,
      'tsummary': tsummary,
      'players': playersData,
      'training': filledTrainingReports,
      'userStats': teamStats,
      'code': 200,
    };
  } catch (error) {
    return {'code': '500', 'error': error.toString()};
  }
}
