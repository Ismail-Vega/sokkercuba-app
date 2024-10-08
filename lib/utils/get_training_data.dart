import '../models/training/training.dart';

PlayerTrainingReport? getPlayerTrainingReport(
    List<PlayerTrainingReport>? players, int id) {
  if (players == null) return null;

  final playerIndex = players.indexWhere((player) => player.id == id);
  final playerReport = playerIndex > -1 ? players[playerIndex] : null;
  return playerReport;
}
