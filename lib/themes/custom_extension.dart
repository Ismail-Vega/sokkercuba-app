import 'dart:ui';

import 'package:flutter/material.dart';

class CustomThemeExtension extends ThemeExtension<CustomThemeExtension> {
  final double smallFontSize;
  final double mediumFontSize;
  final double largeFontSize;
  final double smallPadding;
  final double mediumPadding;
  final double largePadding;

  CustomThemeExtension({
    required this.smallFontSize,
    required this.mediumFontSize,
    required this.largeFontSize,
    required this.smallPadding,
    required this.mediumPadding,
    required this.largePadding,
  });

  factory CustomThemeExtension.of(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double screenMultiplier;

    if (screenWidth < 600) {
      screenMultiplier = 1;
    } else if (screenWidth < 864) {
      screenMultiplier = 0.5;
    } else if (screenWidth < 1200) {
      screenMultiplier = 0.6;
    } else {
      screenMultiplier = 0.4;
    }

    final smallFontSize = screenWidth * 0.028 * screenMultiplier;
    final mediumFontSize = screenWidth * 0.034 * screenMultiplier;
    final largeFontSize = screenWidth * 0.04 * screenMultiplier;

    double smallPadding = screenWidth < 413 ? 4 : 8;
    double mediumPadding = screenWidth < 413 ? 8 : 16;
    double largePadding = screenWidth < 413 ? 16 : 24;

    return CustomThemeExtension(
      smallFontSize: smallFontSize,
      mediumFontSize: mediumFontSize,
      largeFontSize: largeFontSize,
      smallPadding: smallPadding,
      mediumPadding: mediumPadding,
      largePadding: largePadding,
    );
  }

  @override
  ThemeExtension<CustomThemeExtension> copyWith({
    double? smallFontSize,
    double? mediumFontSize,
    double? largeFontSize,
    double? smallPadding,
    double? mediumPadding,
    double? largePadding,
  }) {
    return CustomThemeExtension(
      smallFontSize: smallFontSize ?? this.smallFontSize,
      mediumFontSize: mediumFontSize ?? this.mediumFontSize,
      largeFontSize: largeFontSize ?? this.largeFontSize,
      smallPadding: smallPadding ?? this.smallPadding,
      mediumPadding: mediumPadding ?? this.mediumPadding,
      largePadding: largePadding ?? this.largePadding,
    );
  }

  @override
  ThemeExtension<CustomThemeExtension> lerp(
    ThemeExtension<CustomThemeExtension>? other,
    double t,
  ) {
    if (other is! CustomThemeExtension) return this;
    return CustomThemeExtension(
      smallFontSize: lerpDouble(smallFontSize, other.smallFontSize, t)!,
      mediumFontSize: lerpDouble(mediumFontSize, other.mediumFontSize, t)!,
      largeFontSize: lerpDouble(largeFontSize, other.largeFontSize, t)!,
      smallPadding: lerpDouble(smallPadding, other.smallPadding, t)!,
      mediumPadding: lerpDouble(mediumPadding, other.mediumPadding, t)!,
      largePadding: lerpDouble(largePadding, other.largePadding, t)!,
    );
  }
}
