import 'dart:async';

import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../models/team/team_stats.dart';
import '../models/team/user.dart';
import '../state/actions.dart';
import '../state/app_state_notifier.dart';
import '../utils/app_state_converters.dart';
import 'api_client.dart';
import 'fetch_juniors_training.dart';
import 'toast_service.dart';

Future<Map<String, dynamic>> fetchAllData(ApiClient apiClient,
    AppStateNotifier appStateNotifier, BuildContext context) async {
  final toastService = ToastService(context);

  try {
    final user = await apiClient.fetchData(userUrl);
    final state = appStateNotifier.state;

    if (user != null) {
      final readOnlyMode = user['lock']?['readOnlyMode'];

      if (readOnlyMode) {
        return {
          'success': false,
          'code': 500,
          'message':
              "Sokker data is temporarily unavailable. Please try again later."
        };
      }

      final teamId = user['team']?['id'];

      final List<Future<dynamic>> initialPromises = [
        apiClient.fetchData(juniorsUrl),
        apiClient.fetchData(trainingUrl),
        apiClient.fetchData(tsummaryUrl),
        apiClient.fetchData(getTeamPlayersURL(teamId)),
        apiClient.fetchData(getTeamStatsURL(teamId)),
        apiClient.fetchData(newsUrl),
        apiClient.fetchData('/api/trainer'),
      ];

      final responses = await Future.wait(initialPromises);

      final plus = user['plus'];
      var stateWeek = state.trainingWeek;
      final week = user['today']['week'];
      final day = user['today']['day'];

      if (week != null && day != null) {
        final trainingWeek = day < 5 ? week - 1 : week;

        if (trainingWeek != stateWeek) {
          stateWeek = trainingWeek;
        }
      }

      final juniors = setJuniorsData(state.juniors, responses[0], stateWeek);
      final trainers = parseTrainers(responses[6]?['trainers'] ?? []);
      final training = await setTrainingData(
          apiClient, plus, stateWeek, state.training, responses[1], trainers);
      final tsummary = setTSummaryData(state.tsummary, responses[2]);
      final players = setSquadData(state.players, responses[3], stateWeek);
      final userStats = UserStats.fromJson(responses[4]);
      final news = await setNewsData(apiClient, state.news, responses[5]);

      final juniorsTraining = await getJuniorsTraining(
          apiClient, responses[0]['juniors'], state.juniorsTraining);

      final dataUpdatedOn = DateTime.now().toIso8601String();
      final filteredPayload = {
        'teamId': user['team']?['id'],
        'user': User.fromJson(user),
        'userStats': userStats,
        'juniors': juniors,
        'juniorsTraining': juniorsTraining,
        'tsummary': tsummary,
        'players': players,
        'training': training,
        'news': news,
        'trainingWeek': stateWeek,
        'dataUpdatedOn': dataUpdatedOn,
        'trainers': trainers,
      };

      appStateNotifier
          .dispatch(StoreAction(StoreActionTypes.setAll, filteredPayload));

      return {'success': true, 'code': 200, 'dataUpdatedOn': dataUpdatedOn};
    } else {
      toastService.showToast(
        "Failed to fetch all data!",
        backgroundColor: Colors.red,
      );
      return {'code': '500', 'error': 'Failed to fetch all data!'};
    }
  } catch (error) {
    toastService.showToast(
      "Failed to fetch all data!",
      backgroundColor: Colors.red,
    );

    return {'code': '500', 'error': error.toString()};
  }
}
