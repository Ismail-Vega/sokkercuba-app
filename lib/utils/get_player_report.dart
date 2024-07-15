import '../models/training/training.dart';
import '../models/training/training_report.dart';

List<TrainingReport>? getPlayerTrainingReportById(
    List<PlayerTrainingReport>? players, int id) {
  if (players == null) return null;

  for (var player in players) {
    if (player.id == id) {
      return player.report;
    }
  }
  return null; // Return null if no matching id is found
}
