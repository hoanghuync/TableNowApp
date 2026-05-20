import 'package:intl/intl.dart';

class DateTimeUtils {
  static final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  static String formatDate(DateTime date) => _dateFormat.format(date);

  static DateTime parseDateAndTime(String date, String time) {
    final parts = time.split(':').map(int.parse).toList();
    final parsedDate = DateTime.parse(date);
    return DateTime(parsedDate.year, parsedDate.month, parsedDate.day, parts[0], parts[1]);
  }

  static bool isTimeInsideRange(String time, String openTime, String closeTime) {
    int minutes(String value) {
      final parts = value.split(':').map(int.parse).toList();
      return parts[0] * 60 + parts[1];
    }

    final selected = minutes(time);
    return selected >= minutes(openTime) && selected <= minutes(closeTime);
  }
}


