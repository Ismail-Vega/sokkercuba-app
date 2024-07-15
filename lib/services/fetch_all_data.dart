import 'dart:async';

import '../models/team/user.dart';
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
      return {
        'juniors': juniors,
        'tsummary': tsummary,
        'players': playersData,
        'training': training,
        'userStats': teamStats,
        'code': 200,
      };
    }

    final filledTrainingReports =
        await fillTrainingReports(apiClient, training['players']);

    return {
      'juniors': juniors,
      'tsummary': tsummary,
      'players': playersData,
      'training': filledTrainingReports,
      'userStats': teamStats,
      'code': 200,
    };
  } catch (error) {
    print('error in fetchAll: ${error.toString()}');
    return {'code': '500', 'error': error.toString()};
  }
}

Future<Object> fillTrainingReports(ApiClient apiClient, dynamic players) async {
  if (players == null || players.isEmpty) {
    return [];
  }

  // Fetch full reports for all players
  final List<Future<dynamic>> fullReportPromises =
      players.map<Future<dynamic>>((player) {
    return apiClient.fetchData(getPlayerFullReportURL(player['id']));
  }).toList();

  // Await all the full report promises
  final tResponse = await Future.wait(fullReportPromises);

  // Process the responses and create PlayerTrainingReport objects
  final playerTrainingReports = tResponse.asMap().entries.map((entry) {
    final reports = entry.value['reports'] ?? [];

    // Create a PlayerTrainingReport instance
    return {
      'id': players[entry.key]['id'],
      'player': players[entry.key]['player'],
      'report': reports,
    };
  }).toList();

  // Return SquadTraining instance
  return {'players': playerTrainingReports};
}
