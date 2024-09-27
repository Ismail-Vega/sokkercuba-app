import '../models/player/player.dart';
import '../screens/scouting/scoring_system.dart';

List<TeamPlayer> filteredPlayers(List<TeamPlayer>? players) {
  if (players == null) return [];

  return players.where((player) {
    final scores = filterAndSortPlayerScores(player.info);
    final bestPosition = scores.isNotEmpty ? scores.first.key : 'N/A';
    final bestScore = scores.isNotEmpty ? scores.first.value['score'] : 0.0;
    return bestPosition != 'N/A' && bestScore > 0.0;
  }).toList();
}

List<TeamPlayer> sortedPlayers(List<TeamPlayer>? players) {
  if (players == null) return [];

  return players
    ..sort((a, b) {
      final aScores = filterAndSortPlayerScores(a.info);
      final bScores = filterAndSortPlayerScores(b.info);

      final positionComparison = aScores.first.key.compareTo(bScores.first.key);
      if (positionComparison != 0) return positionComparison;

      return bScores.first.value['score']
          .compareTo(aScores.first.value['score']);
    });
}
