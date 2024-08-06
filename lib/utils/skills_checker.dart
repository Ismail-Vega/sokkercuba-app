import 'package:flutter/material.dart';

import '../models/juniors/progress_value.dart';
import '../models/training/training_report.dart';

Color? getSkillChangeColor(TrainingReport? report, String skill) {
  if (report != null) {
    final skillChange = report.getSkillChange(skill);
    if (skillChange != null) {
      if (skillChange > 0) {
        return Colors.green;
      } else if (skillChange < 0) {
        return Colors.red;
      }
    }
  }

  return null;
}

Color? getJuniorLevelColor(List<ProgressValue>? progressValues) {
  if (progressValues == null || progressValues.length < 2) {
    return null;
  }

  final lastValue = progressValues.last.y;
  final previousValue = progressValues[progressValues.length - 2].y;

  if (lastValue > previousValue) {
    return Colors.green;
  } else if (lastValue < previousValue) {
    return Colors.red;
  } else {
    return null;
  }
}
