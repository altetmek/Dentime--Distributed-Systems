import 'dart:convert';

import 'package:dentime/util/date_util/date_util.dart';
import 'package:uuid/uuid.dart';

class Booking {
  String _id;
  DateTime time;
  String patient;
  String dentist;
  int duration;

  get id => _id;

  Booking(
      {String id,
      DateTime time,
      String patient,
      String dentist,
      int duration}) {
    this._id = id;
    this.time = time;
    this.patient = patient;
    this.dentist = dentist;
    this.duration = duration;
  }
  static get defaultBooking {
    return Booking(
      dentist: null,
      duration: 10,
      id: Uuid().v4(),
      patient: null,
      time: DateTime(2022, 01, 01),
    );
  }

  factory Booking.fromJson(Map<String, dynamic> parsedJson) {
    return Booking(
      id: parsedJson['_id'].toString(),
      time: DateUtil.parseDateString(timeString: parsedJson['time'].toString()),
      patient: parsedJson['patient'].toString(),
      dentist: parsedJson['dentist'].toString(),
      duration: int.parse(parsedJson['duration'].toString()),
    );
  }

  factory Booking.fromJsonString(String data) {
    final Map parsed = json.decode(data);
    return Booking.fromJson(parsed);
  }
}
