import '../models/juniors/progress_value.dart';
import 'skill_parser.dart';

double calculateAverageWeeksPop(List<ProgressValue> values) {
  if (values.isEmpty) return 0;

  int total = values.length - 1;
  int firstY = values.first.y;
  int lastY = values.last.y;

  double incrementDifference = (lastY - firstY).toDouble();

  if (incrementDifference <= 0) return 0;

  double averageWeeksPop = total / incrementDifference;

  return averageWeeksPop;
}

String estimateFinalLevel(
    List<ProgressValue> progress, int min, int max, int remainingWeeks) {
  if (progress.isEmpty) return '0.0';

  double averageChangePerWeek = calculateAverageWeeksPop(progress);
  int currentLevel = progress.last.y;

  if (averageChangePerWeek <= 0) {
    return '≈ ${parseSkillToText(min.toDouble().floor())} [$min]';
  }

  double estimatedFinalLevel =
      currentLevel + (remainingWeeks / averageChangePerWeek);

  if (estimatedFinalLevel < min) {
    estimatedFinalLevel = min.toDouble();
  } else if (estimatedFinalLevel > max) {
    estimatedFinalLevel = max.toDouble();
  }

  return '≈ ${parseSkillToText(estimatedFinalLevel.floor())} [${estimatedFinalLevel.toStringAsFixed(2)}]';
}

int calculateSkillPops(List<ProgressValue> values) {
  if (values.isEmpty) return 0;

  int firstY = values.first.y;
  int lastY = values.last.y;

  double pops = (lastY - firstY).toDouble();

  if (pops <= 0) return 0;

  return pops.floor();
}
