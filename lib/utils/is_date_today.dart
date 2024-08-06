bool isDateToday(String value) {
  final DateTime parsedDate = DateTime.parse(value);
  final DateTime currentDate = DateTime.now();

  final String formattedParsedDate =
      parsedDate.toIso8601String().substring(0, 10);
  final String formattedCurrentDate =
      currentDate.toIso8601String().substring(0, 10);

  return formattedParsedDate == formattedCurrentDate;
}
