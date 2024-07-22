import '../models/juniors/juniors.dart';
import '../models/player/player.dart';
import '../models/player/player_info.dart';
import '../models/squad/squad.dart';
import '../models/training/training.dart';
import '../models/training/training_report.dart';
import '../services/api_client.dart';
import '../utils/app_state_converters.dart';
import '../utils/constants.dart';

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
  setTrainingWeek,
  setLoading,
  setLogin,
  setUser,
  setUserStats,
  setJuniors,
  setJuniorsTraining,
  setSummary,
  setTeam,
  setTraining,
  setAll,
}

Juniors setJuniorsData(Juniors? stateJuniors, Map<String, dynamic> data) {
  final currentJuniors = parseJuniors(data['juniors'] ?? []);
  final currentJuniorsIds = currentJuniors.map((junior) => junior.id).toSet();
  final juniors = stateJuniors != null ? stateJuniors.toJson()['juniors'] : [];
  final prevJuniors =
      stateJuniors != null ? stateJuniors.toJson()['prevJuniors'] : [];
  final leftJuniors = juniors
      .where((junior) => !currentJuniorsIds.contains(junior.id))
      .toList();

  final List<Junior> newPrevJuniors = [
    ...prevJuniors,
    ...leftJuniors.where((junior) => !leftJuniors.contains(junior.id)).toList()
  ];

  return Juniors(
    juniors: currentJuniors,
    prevJuniors: newPrevJuniors,
  );
}

Squad setSquadData(Squad? stateSquad, Map<String, dynamic> data) {
  final totalData = data['total'] ?? 0;
  final playersData = parsePlayers(data['players'] ?? []);
  final currentPlayersIds = playersData.map((player) => player.id).toSet();
  final List<TeamPlayer> players = stateSquad?.players ?? [];
  final List<TeamPlayer> prevPlayers = stateSquad?.prevPlayers ?? [];
  final prevPlayersIds = prevPlayers.map((player) => player.id).toSet();

  final leftPlayers = players
      .where((player) => !currentPlayersIds.contains(player.id))
      .toList();
  final currentPlayers =
      players.where((player) => currentPlayersIds.contains(player.id)).toList();
  final newPrevPlayers = [
    ...prevPlayers,
    ...leftPlayers.where((player) => !prevPlayersIds.contains(player.id))
  ];

  return Squad(
      players: currentPlayers.isEmpty ? playersData : currentPlayers,
      prevPlayers: newPrevPlayers,
      total: totalData);
}

Future<SquadTraining?> fillTrainingReports(
    ApiClient apiClient, dynamic data, SquadTraining? stateData) async {
  final players = data['players'] ?? [];

  if (players.isEmpty) {
    return stateData;
  }

  final List<Future<dynamic>> fullReportPromises =
      players.map<Future<dynamic>>((player) {
    return apiClient.fetchData(getPlayerFullReportURL(player['id']));
  }).toList();

  final tResponse = await Future.wait(fullReportPromises);
  final training = stateData ?? SquadTraining(players: []);

  for (int i = 0; i < tResponse.length; i++) {
    final player = players[i];
    final reports = tResponse[i]['reports'] ?? [];
    bool playerFound = false;

    for (var statePlayerReport in training.players!) {
      if (statePlayerReport.id == player['id']) {
        playerFound = true;

        final Set<int> weeksInFirstList =
            statePlayerReport.report.map((report) => report.week).toSet();

        for (final report in reports) {
          final trainingReport = TrainingReport.fromJson(report);

          if (!weeksInFirstList.contains(trainingReport.week)) {
            statePlayerReport.report.add(trainingReport);
          }
        }

        break;
      }
    }

    if (!playerFound) {
      final newReports = reports
          .map<TrainingReport>((report) => TrainingReport.fromJson(report))
          .toList();

      final playerTrainingReport = PlayerTrainingReport(
        id: player['id'],
        player: PlayerInfo.fromJson(player['player']),
        report: newReports,
      );

      training.players!.add(playerTrainingReport);
    }
  }

  return training;
}
