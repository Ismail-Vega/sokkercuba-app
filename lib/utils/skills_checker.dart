import 'package:flutter/material.dart';

import '../mixins/skills_mixin.dart';
import '../models/juniors/progress_value.dart';
import '../models/player/player_info.dart';

Color? getSkillChangeColor(SkillMethods report, String skill) {
  if (report.skillsChange != null) {
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

Color? getValueChangeColor(PlayerInfo? prevState, PlayerInfo currState) {
  if (prevState != null) {
    if (prevState.value != null) {
      if (prevState.value!.value > currState.value!.value) {
        return Colors.green;
      } else if (prevState.value!.value < currState.value!.value) {
        return Colors.red;
      }
    }
  }

  return null;
}
