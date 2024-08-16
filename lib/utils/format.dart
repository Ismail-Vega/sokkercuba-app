import 'package:intl/intl.dart';

String? formatNumber(int? number) {
  if (number == null) return null;
  final formatter = NumberFormat('#,##0', 'en_US');
  return formatter.format(number).replaceAll(',', ' ');
}

String formatDateTime(DateTime? dateTime, {String locale = 'en_US'}) {
  if (dateTime == null) {
    return 'No date available';
  }

  final DateFormat dateFormatter = DateFormat('MMM d, y', locale);
  final DateFormat timeFormatter = DateFormat('HH:mm:ss', locale);

  final String formattedDate = dateFormatter.format(dateTime);
  final String formattedTime = timeFormatter.format(dateTime);

  return '$formattedDate at $formattedTime';
}
