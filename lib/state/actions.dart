import '../models/juniors/juniors.dart';
import '../models/news/news.dart';
import '../models/news/news_item.dart';
import '../models/news/news_junior.dart';
import '../models/player/player.dart';
import '../models/player/player_info.dart';
import '../models/squad/squad.dart';
import '../models/training/training.dart';
import '../models/training/training_report.dart';
import '../services/api_client.dart';
import '../services/fetch_juniors_news.dart';
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

  final List<Junior> newPrevJuniors = [...prevJuniors, ...leftJuniors];

  return Juniors(
    juniors: currentJuniors,
    prevJuniors: newPrevJuniors,
  );
}

Squad setSquadData(Squad? stateSquad, Map<String, dynamic> data) {
  final totalData = data['total'] ?? 0;
  final playersData = parsePlayers(data['players'] ?? []);
  final List<TeamPlayer> statePlayers = stateSquad?.players ?? [];
  final playersDataIds = playersData.map((player) => player.id).toSet();

  final List<TeamPlayer> prevPlayers = stateSquad?.prevPlayers ?? [];
  final prevPlayersIds = prevPlayers.map((player) => player.id).toSet();

  final List<TeamPlayer> newPrevPlayers = [...prevPlayers];

  for (final player in statePlayers) {
    if (!playersDataIds.contains(player.id)) {
      if (prevPlayersIds.contains(player.id)) {
        final index = newPrevPlayers.indexWhere((p) => p.id == player.id);
        if (index != -1) {
          newPrevPlayers[index] = player;
        }
      } else {
        newPrevPlayers.add(player);
      }
    }
  }

  return Squad(
    players: playersData,
    prevPlayers: newPrevPlayers,
    total: totalData,
  );
}

Future<SquadTraining?> setTrainingData(ApiClient apiClient, bool plus,
    int? week, SquadTraining? stateData, dynamic data) async {
  final players = data['players'] ?? [];

  if (players.isEmpty) {
    return stateData;
  }

  final training = stateData ?? SquadTraining(players: []);

  if (training.players.isNotEmpty) {
    int checkIndex = training.players.indexWhere((player) {
      if (player.report.isNotEmpty) {
        return player.report[0].week == week;
      }
      return false;
    });

    if (checkIndex != -1) {
      return stateData;
    }
  }

  if (!plus) {
    for (var player in players) {
      final report = TrainingReport.fromJson(player['report']);

      final playerTrainingReport = PlayerTrainingReport(
        id: player['id'],
        player: PlayerInfo.fromJson(player['player']),
        report: [report],
      );

      if (training.players.isNotEmpty) {
        int tIndex = training.players
            .indexWhere((tplayer) => tplayer.id == player['id']);

        if (tIndex != -1) {
          if (training.players[tIndex].report[0].week != week) {
            training.players[tIndex].report.insert(0, report);
          }
        } else {
          training.players.add(playerTrainingReport);
        }
      } else {
        training.players.add(playerTrainingReport);
      }
    }

    return training;
  }

  final List<Future<dynamic>> fullReportPromises =
      players.map<Future<dynamic>>((player) {
    return apiClient.fetchData(getPlayerFullReportURL(player['id']));
  }).toList();

  final tResponse = await Future.wait(fullReportPromises);

  for (int i = 0; i < tResponse.length; i++) {
    final player = players[i];
    final reports = tResponse[i]['reports'] ?? [];
    bool playerFound = false;

    for (var statePlayerReport in training.players) {
      if (statePlayerReport.id == player['id']) {
        playerFound = true;

        final Set<int> weeksInFirstList =
            statePlayerReport.report.map((report) => report.week).toSet();

        for (final report in reports) {
          final trainingReport = TrainingReport.fromJson(report);

          if (!weeksInFirstList.contains(trainingReport.week)) {
            statePlayerReport.report.insert(0, trainingReport);
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

      training.players.add(playerTrainingReport);
    }
  }

  return training;
}

Future<News> setNewsData(
    ApiClient apiClient, News? stateNews, Map<String, dynamic> data) async {
  final newsData = parseNews(data['news'] ?? []);
  final List<NewsItem> currentNews = stateNews?.news ?? [];
  final List<NewsJunior> currentJuniors = stateNews?.juniors ?? [];
  final currentNewsIds = currentNews.map((item) => item.id).toSet();

  final incomingNews = newsData
      .where(
        (item) =>
            !currentNewsIds.contains(item.id) &&
            item.kind == 'youth_school' &&
            item.type == 2,
      )
      .toList();

  final newNews = [...currentNews, ...incomingNews];
  final incomingJuniors = await getJuniorNews(apiClient, incomingNews);
  final List<NewsJunior> newJuniors = [...currentJuniors, ...incomingJuniors];

  return News(
      news: currentNews.isEmpty ? newsData : newNews,
      juniors: newJuniors,
      total: currentNews.isEmpty ? newsData.length : newNews.length);
}
