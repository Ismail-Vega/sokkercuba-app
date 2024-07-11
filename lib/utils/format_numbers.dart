import 'package:intl/intl.dart';

String formatNumber(int number) {
  final formatter = NumberFormat('#,##0', 'en_US');
  return formatter.format(number).replaceAll(',', ' ');
}
