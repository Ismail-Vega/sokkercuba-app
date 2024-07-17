import '../models/juniors/juniors.dart';
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

Juniors setJuniorsData(Juniors? stateJuniors, Map<String, dynamic> data) {
  final currentJuniors = parseJuniors(data['juniors'] ?? []);
  final currentJuniorsIds = currentJuniors.map((junior) => junior.id).toSet();
  final juniors = stateJuniors != null ? stateJuniors.toJson()['juniors'] : [];
  final prevJuniors =
      stateJuniors != null ? stateJuniors.toJson()['prevJuniors'] : [];
  final leftJuniors =
      juniors.where((junior) => !currentJuniorsIds.contains(junior.id));

  final List<Junior> newPrevJuniors = [
    ...prevJuniors,
    ...leftJuniors.where((junior) => !leftJuniors.contains(junior.id))
  ];

  return Juniors(
    juniors: currentJuniors,
    prevJuniors: newPrevJuniors,
  );
}

Squad setSquadData(Squad? stateSquad, Map<String, dynamic> data) {
  final currentPlayers = parsePlayers(data['players'] ?? []);
  final currentPlayersIds = currentPlayers.map((player) => player.id).toSet();
  final players = stateSquad != null ? stateSquad.toJson()['players'] : [];
  final prevPlayers =
      stateSquad != null ? stateSquad.toJson()['prevPlayers'] : [];
  final leftPlayers =
      players.where((player) => !currentPlayersIds.contains(player.id));
  final List<TeamPlayer> newPrevPlayers = [
    ...prevPlayers,
    ...leftPlayers.where((player) => !prevPlayers.contains(player.id))
  ];

  return Squad(
      players: currentPlayers,
      prevPlayers: newPrevPlayers,
      total: currentPlayers.length);
}

Future<SquadTraining> fillTrainingReports(
    ApiClient apiClient, dynamic data) async {
  final currentPlayers = data['players'] ?? [];

  if (currentPlayers == null || currentPlayers.isEmpty) {
    return SquadTraining(players: {});
  }

  final List<Future<dynamic>> fullReportPromises =
      currentPlayers.map<Future<dynamic>>((player) {
    return apiClient.fetchData(getPlayerFullReportURL(player['id']));
  }).toList();

  final tResponse = await Future.wait(fullReportPromises);
  final Map<String, PlayerTrainingReport> playerTrainingReportMap = {};

  for (int i = 0; i < tResponse.length; i++) {
    final player = currentPlayers[i];
    final reports = tResponse[i]['reports'] ?? [];

    for (final report in reports) {
      final playerTrainingReport = PlayerTrainingReport(
        id: player['id'],
        player: PlayerInfo.fromJson(player['player']),
        report: TrainingReport.fromJson(report),
      );

      final key = '${player['id']}_${report['week']}';
      playerTrainingReportMap[key] = playerTrainingReport;
    }
  }

  return SquadTraining(players: playerTrainingReportMap);
}
