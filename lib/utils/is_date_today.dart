bool isDateToday(String value) {
  // Parse the date string into a DateTime object
  final DateTime parsedDate = DateTime.parse(value);

  // Get the current date
  final DateTime currentDate = DateTime.now();

  // Format both dates to yyyy-MM-dd to ignore time part
  final String formattedParsedDate =
      parsedDate.toIso8601String().substring(0, 10);
  final String formattedCurrentDate =
      currentDate.toIso8601String().substring(0, 10);

  // Compare the dates and return the result
  return formattedParsedDate == formattedCurrentDate;
}
