import 'package:flutter/material.dart';

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

  return null; // Use primary color or null
}
