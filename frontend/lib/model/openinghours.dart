enum Day { monday, tuesday, wednesday, thursday, friday, saturday, sunday }

class OpeningHours {
  String _id;
  Day day;
  String hours;

  OpeningHours({String id, Day day, String hours}) {
    this._id = id;
    this.day = day;
    this.hours = hours;
  }
}
