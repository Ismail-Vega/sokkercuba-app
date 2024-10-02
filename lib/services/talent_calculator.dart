import '../models/coach/trainer.dart';
import '../models/player/player_info.dart';
import '../models/training/training.dart';
import '../models/training/training_report.dart';

class PlayerSkillProgress {
  static const int baseGoalValue = 100;
  static const int agePenaltyStart = 27;
  static const double baseAgeDecayFactor = 0.05;
  static const double headCoachWeight = 0.7;
  static const double assistantsWeight = 0.3;

  static const skillDifficultyModifiers = {
    'pace': 2.0,
    'defending': 1.5,
    'striker': 1.5,
    'keeper': 1.5,
    'passing': 1.2,
    'playmaking': 1.2,
    'technique': 1.0,
    'stamina': 0.5,
  };

  static double calculateTalentFactor(double averageWeeksPop) {
    return averageWeeksPop > 0 ? 1 / averageWeeksPop : 1;
  }

  static double calculateAgeFactor(int age) {
    if (age <= 23) {
      return 1.2;
    }
    if (age > 23 && age <= 27) {
      return 1 - (0.05 * (age - 23));
    }
    return 1 - (0.1 * (age - 27));
  }

  static double calculateSkillLevelFactor(int currentSkillValue) {
    if (currentSkillValue >= 1 && currentSkillValue <= 9) {
      return 1 + (currentSkillValue * 0.05);
    } else if (currentSkillValue >= 10 && currentSkillValue <= 13) {
      return 1 + (currentSkillValue * 0.15);
    } else if (currentSkillValue >= 14 && currentSkillValue <= 16) {
      return 2;
    } else if (currentSkillValue >= 17) {
      return 3;
    }
    return 1;
  }

  static double calculateCoachEffectiveness(
      List<Trainer> trainers, String skill) {
    double headCoachEffectiveness = 0;
    double assistantsAveragePercent = 0;
    int assistantsCount = 0;

    for (var trainer in trainers) {
      if (trainer.info.assignment.name == "first") {
        headCoachEffectiveness =
            _getSkillPercentForCoach(trainer.info.skills, skill);
      } else if (trainer.info.assignment.name == "assistant") {
        assistantsAveragePercent += trainer.info.skills.averagePercent;
        assistantsCount++;
      }
    }

    if (assistantsCount > 0) {
      assistantsAveragePercent /= assistantsCount;
    }

    return (headCoachEffectiveness * headCoachWeight) +
        (assistantsAveragePercent * assistantsWeight);
  }

  static double _getSkillPercentForCoach(TrainerSkills skills, String skill) {
    switch (skill) {
      case 'stamina':
        return skills.stamina.percent.toDouble();
      case 'keeper':
        return skills.keeper.percent.toDouble();
      case 'playmaking':
        return skills.playmaking.percent.toDouble();
      case 'passing':
        return skills.passing.percent.toDouble();
      case 'technique':
        return skills.technique.percent.toDouble();
      case 'defending':
        return skills.defending.percent.toDouble();
      case 'striker':
        return skills.striker.percent.toDouble();
      case 'pace':
        return skills.pace.percent.toDouble();
      default:
        return 0;
    }
  }

  static double calculateWeeklyProgress({
    required String skill,
    required double trainingIntensity,
    required int age,
    required double talentFactor,
    required List<Trainer> trainers,
    required int currentSkillValue,
    required bool isMainTraining,
  }) {
    double skillModifier = skillDifficultyModifiers[skill] ?? 1.0;
    double ageFactor = calculateAgeFactor(age);
    double coachEffectiveness =
        calculateCoachEffectiveness(trainers, skill) / 100;
    double skillLevelFactor = calculateSkillLevelFactor(currentSkillValue);

    double trainingMultiplier = isMainTraining ? 1.0 : 0.1;

    return trainingIntensity *
        talentFactor *
        (1 / skillModifier) *
        (1 / ageFactor) *
        (1 / skillLevelFactor) *
        coachEffectiveness *
        trainingMultiplier;
  }

  static List<TrainingReport> getReportsSinceLastIncrease(
      List<TrainingReport> reports, String skillName) {
    if (reports.isEmpty) return [];

    List<TrainingReport> reportsSinceLastIncrease = [];

    for (int i = 0; i < reports.length; i++) {
      TrainingReport report = reports[i];

      final kind = report.kind.name;
      final intensity = report.intensity;

      if (report.type.name == skillName &&
          kind != 'missing' &&
          intensity >= 50) {
        final currentSkillValue = report.getSkill(skillName);

        if (i < reports.length - 1) {
          final previousSkillValue = reports[i + 1].getSkill(skillName);

          if (currentSkillValue != null &&
              previousSkillValue != null &&
              currentSkillValue > previousSkillValue) {
            break;
          }
        }

        reportsSinceLastIncrease.add(report);
      }
    }

    return reportsSinceLastIncrease;
  }

  static Map<String, double> calculateSkillProgress(
      PlayerTrainingReport playerTrainingReport,
      List<Trainer> trainers,
      Map<String, double> skillGrowth) {
    PlayerInfo playerInfo = playerTrainingReport.player;
    List<TrainingReport> trainingReports = playerTrainingReport.report;

    List<String> skillNames = [
      'stamina',
      'pace',
      'technique',
      'passing',
      'keeper',
      'defending',
      'playmaking',
      'striker'
    ];

    Map<String, double> updatedSkillProgress = {};

    for (String skillName in skillNames) {
      List<TrainingReport> reportsSinceIncrease = getReportsSinceLastIncrease(
        trainingReports,
        skillName,
      );
      double accumulatedProgress = playerInfo.skillProgress[skillName] ?? 0.0;
      double talentFactor = calculateTalentFactor(skillGrowth[skillName] ?? 0);

      for (TrainingReport report in reportsSinceIncrease) {
        int? skillValue = report.getSkill(skillName);
        if (skillValue == null ||
            report.kind.name == 'missing' ||
            report.intensity < 50) {
          continue;
        }

        bool isMainTraining = skillName == report.type.name;

        double weeklyProgress = calculateWeeklyProgress(
          skill: skillName,
          trainingIntensity: report.intensity.toDouble(),
          age: playerInfo.characteristics.age,
          talentFactor: talentFactor,
          trainers: trainers,
          currentSkillValue: skillValue,
          isMainTraining: isMainTraining,
        );

        accumulatedProgress += weeklyProgress;

        if (accumulatedProgress >= baseGoalValue) {
          accumulatedProgress -= baseGoalValue;
        }
      }

      updatedSkillProgress[skillName] = accumulatedProgress;
    }

    return updatedSkillProgress;
  }
}
