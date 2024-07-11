import 'package:flutter/material.dart';

Color? getSkillChangeColor(
  int? skillChange,
) {
  if (skillChange == null) return null;

  if (skillChange > 0) {
    return Colors.green;
  } else if (skillChange < 0) {
    return Colors.red;
  } else {
    return null; // Use primary color or null
  }
}
