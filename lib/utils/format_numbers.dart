import 'package:intl/intl.dart';

String? formatNumber(int? number) {
  if (number == null) return null;
  final formatter = NumberFormat('#,##0', 'en_US');
  return formatter.format(number).replaceAll(',', ' ');
}
