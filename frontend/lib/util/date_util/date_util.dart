class DateUtil {
  static DateTime parseDateString({String timeString}) {
    return DateTime.parse(timeString);
  }

  static String getFormatedTimeString(DateTime time) {
    if (time == null) {
      return "unknown";
    }
    time = time.toLocal();
    return "${time.hour.toString().length == 2 ? time.hour.toString() : "0" + time.hour.toString()}:${time.minute.toString().length == 2 ? time.minute.toString() : "0" + time.minute.toString()}";
  }

  static String getDateString(DateTime time) {
    if (time == null) {
      return "unknown";
    }
    time = time.toLocal();
    return "${time.day.toString().length == 2 ? time.day.toString() : "0" + time.day.toString()}/${time.month.toString().length == 2 ? time.month.toString() : "0" + time.month.toString()}-${time.year}";
  }

  static bool isSameDate(DateTime time1, DateTime time2) {
    time2 = time2.toLocal();
    time1 = time1.toLocal();
    return time1.year == time2.year &&
        time1.month == time2.month &&
        time1.day == time2.day;
  }

  static getFullDateTimeString(DateTime time) {
    return "${getDateString(time)} ${getFormatedTimeString(time)}";
  }
}
