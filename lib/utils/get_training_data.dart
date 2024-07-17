import '../models/training/training.dart';
import '../models/training/training_report.dart';

TrainingReport? getPlayerTrainingReport(
    Map<String, PlayerTrainingReport>? players, int id, int? week) {
  if (players == null || week == null) return null;

  return players['${id}_$week']?.report;
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
