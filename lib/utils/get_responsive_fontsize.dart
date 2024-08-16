import 'package:flutter/cupertino.dart';

double getResponsiveFontSize(BuildContext context, double baseSize) {
  double screenWidth = MediaQuery.of(context).size.width;

  return baseSize * screenWidth * 0.003;
}
