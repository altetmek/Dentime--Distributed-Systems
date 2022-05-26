export default class DateUtil {
  static getDayOfWeek(date) {
    switch (date.getDay()) {
      case 0:
        return "sunday";
      case 1:
        return "monday";
      case 2:
        return "tuesday";
      case 3:
        return "wednesday";
      case 4:
        return "thursday";
      case 5:
        return "friday";
      case 6:
        return "saturday";
      default:
        return null;
    }
  }

  static parseTime(timeString) {
    const timeSplit = timeString.split(":");
    const hours = timeSplit[0];
    const minutes = timeSplit[1];

    let time = new Date("1970", "01", "01", hours, minutes);
    return time;
  }

  static getMillisFromSeconds(seconds) {
    return seconds * 1000;
  }

  static getMillisFromMinutes(minutes) {
    return minutes * 60000;
  }

  static getMillisFromHours(hours) {
    return this.getMillisFromMinutes(hours * 60);
  }

  static getMillisFromDays(days) {
    return this.getMillisFromHours(days * 24);
  }
}
