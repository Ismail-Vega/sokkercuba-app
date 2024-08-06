import 'package:flutter/material.dart';

IconData getIconForKind(String kind) {
  switch (kind) {
    case 'individual':
      return Icons.circle;
    case 'formation':
      return Icons.circle;
    case 'missing':
      return Icons.circle;
    case 'injured':
      return Icons.local_hospital;
    default:
      return Icons.circle;
  }
}

Color getColorForKind(String kind) {
  switch (kind) {
    case 'individual':
      return Colors.green[400]!;
    case 'formation':
      return Colors.grey[700]!;
    case 'missing':
      return Colors.red;
    case 'injured':
      return Colors.red;
    default:
      return Colors.red;
  }
}
