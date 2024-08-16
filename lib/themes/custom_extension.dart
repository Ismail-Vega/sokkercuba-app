import 'dart:ui';

import 'package:flutter/material.dart';

class CustomThemeExtension extends ThemeExtension<CustomThemeExtension> {
  final double smallFontSize;
  final double mediumFontSize;
  final double largeFontSize;
  final double paddingSmall;
  final double paddingMedium;
  final double paddingLarge;

  CustomThemeExtension({
    required this.smallFontSize,
    required this.mediumFontSize,
    required this.largeFontSize,
    required this.paddingSmall,
    required this.paddingMedium,
    required this.paddingLarge,
  });

  factory CustomThemeExtension.of(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final smallFontSize = screenWidth * 0.028;
    final mediumFontSize = screenWidth * 0.034;
    final largeFontSize = screenWidth * 0.05;

    double paddingSmall = screenWidth < 415 ? 4 : 8;
    double paddingMedium = screenWidth < 415 ? 8 : 16;
    double paddingLarge = screenWidth < 415 ? 16 : 24;

    return CustomThemeExtension(
      smallFontSize: smallFontSize,
      mediumFontSize: mediumFontSize,
      largeFontSize: largeFontSize,
      paddingSmall: paddingSmall,
      paddingMedium: paddingMedium,
      paddingLarge: paddingLarge,
    );
  }

  @override
  ThemeExtension<CustomThemeExtension> copyWith({
    double? smallFontSize,
    double? mediumFontSize,
    double? largeFontSize,
    double? paddingSmall,
    double? paddingMedium,
    double? paddingLarge,
  }) {
    return CustomThemeExtension(
      smallFontSize: smallFontSize ?? this.smallFontSize,
      mediumFontSize: mediumFontSize ?? this.mediumFontSize,
      largeFontSize: largeFontSize ?? this.largeFontSize,
      paddingSmall: paddingSmall ?? this.paddingSmall,
      paddingMedium: paddingMedium ?? this.paddingMedium,
      paddingLarge: paddingLarge ?? this.paddingLarge,
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
      paddingSmall: lerpDouble(paddingSmall, other.paddingSmall, t)!,
      paddingMedium: lerpDouble(paddingMedium, other.paddingMedium, t)!,
      paddingLarge: lerpDouble(paddingLarge, other.paddingLarge, t)!,
    );
  }
}
