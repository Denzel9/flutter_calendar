import 'package:flutter/material.dart';

final now = DateTime.now();

final currentMonth = now.month;
final currenDay = now.day;
final currenYear = now.year;
final currenWeekDayIndex = now.weekday;
final currenHour = now.hour;

final String monthSlice = monthNames[currentMonth - 1];
final String weekDayName = weekDays[currenWeekDayIndex - 1];

List<String> weekDays = [
  "Monday",
  "Tuesday",
  "Wednesday",
  "Thursday",
  "Friday",
  "Saturday",
  "Sunday"
];

List<String> monthNames = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

List<String> monthsFullNames = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

List<String> weekDaysSlice = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'San'];

String getDayTitle() {
  if (currenHour > 3 && currenHour < 12) return 'Morning';
  if (currenHour >= 12 && currenHour < 17) return 'Afternoon';
  if (currenHour >= 17 && currenHour < 22) return 'Evening';
  if (currenHour >= 22) return 'Night';
  return 'Day';
}

String formatDatePadLeft(int string) {
  return string.toString().padLeft(2, '0');
}

String getFormatDate(String date) {
  if (date.isNotEmpty) {
    DateTime newDate = DateTime.parse(date);
    return '${weekDaysSlice[newDate.weekday - 1]} ${newDate.day} ${monthNames[newDate.month - 1]}, ${newDate.year}';
  } else {
    return '';
  }
}

String getFormatTime(String date) {
  if (date.isNotEmpty) {
    DateTime newDate = DateTime.parse(date);
    return '${formatDatePadLeft(newDate.hour)}:${formatDatePadLeft(newDate.minute)}';
  } else {
    return '';
  }
}

String getSliceDate(String date) {
  String newDate = date.split(' ')[0];
  return newDate;
}

num getSliceDay(String date) {
  String newDate = date.split(' ')[0].split('-')[2];
  return num.parse(newDate);
}

num getSliceYear(String date) {
  String newDate = date.split(' ')[0].split('-')[0];
  return num.parse(newDate);
}

int getWeekday(int month) => DateTime(currenYear, month + 1).weekday - 1;

Map<dynamic, dynamic> computeDates(int value) {
  final obj = {};
  for (var i = 0; i < value; i++) {
    obj[monthsFullNames[i]] = generateCalendar(i);
  }
  return obj;
}

List<DateTime> generateCalendar(int month) {
  final int weekday = getWeekday(month);

  DateTimeRange dateTimeRange = DateTimeRange(
      start: DateTime(now.year, month + 1), end: DateTime(now.year, month + 2));

  final daysToGenerate =
      dateTimeRange.end.difference(dateTimeRange.start).inDays;

  final days = List.generate(
    daysToGenerate,
    (i) => DateTime(
      dateTimeRange.start.year,
      dateTimeRange.start.month,
      dateTimeRange.start.day + (i),
    ),
  );

  return [...List.generate(weekday, (_) => DateTime(1000, 01, 01)), ...days];
}
