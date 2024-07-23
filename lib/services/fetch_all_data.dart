import 'dart:async';

import 'package:sokker_pro/state/app_state.dart';

import '../models/team/team_stats.dart';
import '../models/team/user.dart';
import '../models/tsummary/tsummary.dart';
import '../state/actions.dart';
import '../utils/constants.dart';
import 'api_client.dart';

Future<Map<String, dynamic>> fetchAllData(
    ApiClient apiClient, User user, AppState state) async {
  try {
    final teamId = user.team.id;
    final plus = user.plus;
    final trainingWeek = state.trainingWeek;

    final List<Future<dynamic>> initialPromises = [
      apiClient.fetchData(juniorsUrl),
      apiClient.fetchData(trainingUrl),
      apiClient.fetchData(tsummaryUrl),
      apiClient.fetchData(getTeamPlayersURL(teamId)),
      apiClient.fetchData(getTeamStatsURL(teamId)),
      apiClient.fetchData(newsUrl),
    ];

    final responses = await Future.wait(initialPromises);
    final juniors = setJuniorsData(state.juniors, responses[0]);
    final training = await setTrainingData(
        apiClient, plus, trainingWeek, state.training, responses[1]);
    final tsummary = TSummary.fromJson(responses[2]);
    final playersData = setSquadData(state.players, responses[3]);
    final teamStats = UserStats.fromJson(responses[4]);
    final news = await setNewsData(apiClient, state.news, responses[5]);

    return {
      'juniors': juniors,
      'tsummary': tsummary,
      'players': playersData,
      'training': training,
      'userStats': teamStats,
      'news': news,
      'code': 200,
    };
  } catch (error) {
    return {'code': '500', 'error': error.toString()};
  }
}
