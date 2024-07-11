import '../models/training/training.dart';

PlayerTrainingReport? getPlayerTrainingReportById(
    List<PlayerTrainingReport>? players, int id) {
  if (players == null) return null;

  for (var player in players) {
    if (player.id == id) {
      return player;
    }
  }
  return null; // Return null if no matching id is found
}
