import '../models/training/training.dart';
import '../models/training/training_report.dart';

TrainingReport? getPlayerTrainingReport(
    List<PlayerTrainingReport>? players, int id, int? week) {
  if (players == null || week == null) return null;

  final playerIndex = players.indexWhere((player) => player.id == id);
  final playerReport = playerIndex > -1 ? players[playerIndex].report : [];
  final reportIndex = playerReport.indexWhere((rep) => rep.week == week);
  return reportIndex > -1 ? playerReport[reportIndex] : null;
}

List<PlayerTrainingReport>? getPlayerTrainingReports(
    Map<String, PlayerTrainingReport>? players, int id) {
  if (players == null) return null;

  List<PlayerTrainingReport> result = [];

  players.forEach((key, value) {
    if (value.id == id) {
      return result.add(value);
    }
  });

  return result;
}
