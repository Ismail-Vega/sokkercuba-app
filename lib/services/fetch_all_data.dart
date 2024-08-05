import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/team/team_stats.dart';
import '../models/team/user.dart';
import '../models/tsummary/tsummary.dart';
import '../state/actions.dart';
import '../state/app_state_notifier.dart';
import '../utils/constants.dart';
import 'api_client.dart';
import 'fetch_juniors_training.dart';

Future<Map<String, dynamic>> fetchAllData(
    ApiClient apiClient, AppStateNotifier appStateNotifier) async {
  try {
    final user = await apiClient.fetchData('/current');
    final state = appStateNotifier.state;

    if (user != null) {
      final teamId = user['team']?['id'];
      final plus = user['plus'];
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
      final players = setSquadData(state.players, responses[3]);
      final userStats = UserStats.fromJson(responses[4]);
      final news = await setNewsData(apiClient, state.news, responses[5]);

      final juniorsTraining =
          await getJuniorsTraining(apiClient, responses[0]['juniors']);

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
      };

      appStateNotifier
          .dispatch(StoreAction(StoreActionTypes.setAll, filteredPayload));

      return {
        'success': true,
        'code': 200,
      };
    } else {
      Fluttertoast.showToast(
          msg: "Failed to fetch all data!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return {'code': '500', 'error': 'Failed to fetch all data!'};
    }
  } catch (error) {
    return {'code': '500', 'error': error.toString()};
  }
}
