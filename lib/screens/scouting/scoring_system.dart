import '../../models/player/player_info.dart';
import '../../models/player/skills.dart';

class PositionScores {
  double goalkeeperScore(Skills skills) {
    return skills.keeper * 3.75 + skills.pace * 1.25 + skills.passing * 1;
  }

  double defenderScore(Skills skills) {
    return skills.pace * 1.5 +
        skills.defending * 2.7 +
        skills.technique * 0.6 +
        skills.stamina * 0.6 +
        skills.passing * 0.6;
  }

  double defensiveMidfielderScore(Skills skills) {
    return skills.pace * 1.5 +
        skills.defending * 1.2 +
        skills.technique * 1.1 +
        skills.stamina * 1.1 +
        skills.passing * 1.1;
  }

  double offensiveMidfielderScore(Skills skills) {
    return skills.pace * 1.5 +
        skills.technique * 1.3 +
        skills.passing * 1.4 +
        skills.stamina * 1.4 +
        skills.striker * 0.1 +
        skills.defending * 0.3;
  }

  double wingerScore(Skills skills) {
    return skills.pace * 2 +
        skills.technique * 1.5 +
        skills.passing * 1.3 +
        skills.stamina * 0.8 +
        skills.playmaking * 0.4;
  }

  double scorerScore(Skills skills) {
    return skills.pace * 1.8 +
        skills.technique * 1.2 +
        skills.stamina * 0.2 +
        skills.striker * 2.4 +
        skills.passing * 0.2 +
        skills.defending * 0.2;
  }
}

const Map<int, Map<String, int>> minimumScores = {
  16: {'GK': 30, 'DEF': 20, 'MDEF': 20, 'MOFF': 20, 'WING': 20, 'ATT': 20},
  17: {'GK': 35, 'DEF': 30, 'MDEF': 30, 'MOFF': 30, 'WING': 30, 'ATT': 30},
  18: {'GK': 45, 'DEF': 40, 'MDEF': 40, 'MOFF': 40, 'WING': 40, 'ATT': 40},
  19: {'GK': 50, 'DEF': 45, 'MDEF': 45, 'MOFF': 45, 'WING': 45, 'ATT': 45},
  20: {'GK': 60, 'DEF': 50, 'MDEF': 50, 'MOFF': 50, 'WING': 50, 'ATT': 50},
  21: {'GK': 65, 'DEF': 60, 'MDEF': 60, 'MOFF': 60, 'WING': 60, 'ATT': 60},
  22: {'GK': 70, 'DEF': 65, 'MDEF': 65, 'MOFF': 65, 'WING': 65, 'ATT': 65},
  23: {'GK': 75, 'DEF': 70, 'MDEF': 70, 'MOFF': 70, 'WING': 70, 'ATT': 70},
  24: {'GK': 80, 'DEF': 75, 'MDEF': 75, 'MOFF': 75, 'WING': 75, 'ATT': 75},
  25: {'GK': 85, 'DEF': 80, 'MDEF': 80, 'MOFF': 80, 'WING': 80, 'ATT': 80},
  26: {'GK': 90, 'DEF': 85, 'MDEF': 85, 'MOFF': 85, 'WING': 85, 'ATT': 85},
  27: {'GK': 90, 'DEF': 85, 'MDEF': 85, 'MOFF': 85, 'WING': 85, 'ATT': 85},
  28: {'GK': 90, 'DEF': 90, 'MDEF': 90, 'MOFF': 90, 'WING': 90, 'ATT': 90},
  29: {'GK': 90, 'DEF': 90, 'MDEF': 90, 'MOFF': 90, 'WING': 90, 'ATT': 90},
  30: {'GK': 90, 'DEF': 90, 'MDEF': 90, 'MOFF': 90, 'WING': 90, 'ATT': 90},
};

List<MapEntry<String, double>> filterAndSortPlayerScores(PlayerInfo info) {
  PositionScores positionScores = PositionScores();
  Skills skills = info.skills;
  int age = info.characteristics.age;

  double gkScore = positionScores.goalkeeperScore(skills);
  double defScore = positionScores.defenderScore(skills);
  double mdefScore = positionScores.defensiveMidfielderScore(skills);
  double moffScore = positionScores.offensiveMidfielderScore(skills);
  double wingScore = positionScores.wingerScore(skills);
  double attScore = positionScores.scorerScore(skills);

  Map<String, int> minScores = minimumScores[age] ?? {};

  Map<String, double> filteredScores = {
    'GK': gkScore,
    'DEF': defScore,
    'MDEF': mdefScore,
    'MOFF': moffScore,
    'WING': wingScore,
    'ATT': attScore,
  }..removeWhere((position, score) => score < (minScores[position] ?? 0));

  var sortedScores = filteredScores.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));

  return sortedScores;
}
