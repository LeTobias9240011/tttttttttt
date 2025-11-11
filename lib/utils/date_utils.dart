import 'package:intl/intl.dart';

class AppDateUtils {
  static String formatDate(DateTime date) {
    return DateFormat('dd.MM.yyyy').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('dd.MM.yyyy HH:mm').format(date);
  }

  static String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  static String formatRelative(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Gerade eben';
        }
        return 'vor ${difference.inMinutes} Min.';
      }
      return 'vor ${difference.inHours} Std.';
    } else if (difference.inDays == 1) {
      return 'Gestern';
    } else if (difference.inDays < 7) {
      return 'vor ${difference.inDays} Tagen';
    } else {
      return formatDate(date);
    }
  }

  static DateTime getWeekStart(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  static DateTime getWeekEnd(DateTime date) {
    return date.add(Duration(days: 7 - date.weekday));
  }

  static bool isSameWeek(DateTime date1, DateTime date2) {
    final weekStart1 = getWeekStart(date1);
    final weekStart2 = getWeekStart(date2);
    return weekStart1.year == weekStart2.year &&
        weekStart1.month == weekStart2.month &&
        weekStart1.day == weekStart2.day;
  }
}
