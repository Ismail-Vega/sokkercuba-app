import 'package:intl/intl.dart';

String? formatNumber(int? number) {
  if (number == null) return null;
  final formatter = NumberFormat('#,##0', 'en_US');
  return formatter.format(number).replaceAll(',', ' ');
}

String formatDateTime(String? date, {String locale = 'en_US'}) {
  if (date == null) {
    return 'No date available';
  }

  final dateTime = DateTime.parse(date);
  final DateFormat dateFormatter = DateFormat('MMM d, y', locale);
  final DateFormat timeFormatter = DateFormat('HH:mm:ss', locale);

  final String formattedDate = dateFormatter.format(dateTime);
  final String formattedTime = timeFormatter.format(dateTime);

  return '$formattedDate at $formattedTime';
}
