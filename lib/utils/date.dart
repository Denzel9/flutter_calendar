final now = DateTime.now();
DateTime selectedDate = DateTime.now();
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
  DateTime newDate = DateTime.parse(date);
  return '${weekDaysSlice[newDate.weekday - 1]} ${newDate.day} ${monthNames[newDate.month - 1]}, ${newDate.year}';
}

String getFormatTime(String date) {
  DateTime newDate = DateTime.parse(date);
  return '${formatDatePadLeft(newDate.hour)}:${formatDatePadLeft(newDate.minute)}';
}

String getSliceDate(String date) {
  String newDate = date.split(' ')[0];
  return newDate;
}
