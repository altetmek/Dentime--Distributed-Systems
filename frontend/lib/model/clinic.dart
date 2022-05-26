import 'dart:convert';

import 'package:dentime/model/coodinate.dart';
import 'package:dentime/model/openinghours.dart';
import 'package:dentime/util/date_util/date_util.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Clinic {
  String _id;
  int externalId;
  String name;
  String owner;
  int dentists;
  String address;
  String city;
  List<DateTime> availability = List<DateTime>();

  Coordinate coordinate;
  List<OpeningHours> openingHours;

  get id => _id;

  Clinic({
    String id,
    int externalId,
    String name,
    String owner,
    int dentists,
    String address,
    String city,
    Coordinate coordinate,
    List<OpeningHours> openingHours,
  }) {
    this._id = id;
    this.externalId = externalId;
    this.name = name;
    this.owner = owner;
    this.dentists = dentists;
    this.address = address;
    this.city = city;
    this.coordinate = coordinate;
    this.openingHours = openingHours;
  }

  distanceFrom(LatLng point) {
    return point != null
        ? Geolocator.distanceBetween(point.latitude, point.longitude,
            coordinate.latitude, coordinate.longitude)
        : 0;
  }

  String getMarkerColour() {
    DateTime nextBookingTime = getNextBookingTime();
    if (nextBookingTime == null) {
      return 'grey';
    }
    if (DateUtil.isSameDate(DateTime.now(), nextBookingTime)) {
      return 'green';
    }
    if (DateUtil.isSameDate(
        DateTime.now().add(Duration(days: 1)), nextBookingTime)) {
      return 'yellow';
    }
    if (DateUtil.isSameDate(
        DateTime.now().add(Duration(days: 2)), nextBookingTime)) {
      return 'orange';
    } else {
      return 'red';
    }
  }

  DateTime getNextBookingTime() {
    final upcomingAvailabilities = getUpcomingAvailabilities();
    DateTime nextAvailable;
    upcomingAvailabilities.forEach((time) {
      if (nextAvailable == null) {
        nextAvailable = time;
      } else if (nextAvailable.isAfter(time)) {
        nextAvailable = time;
      }
    });
    return nextAvailable;
  }

  getUpcomingAvailabilities() {
    DateTime now = DateTime.now();
    now.add(Duration(minutes: 5));
    // Log.d(bookings.length.toString());
    // Log.d(now.toString());
    final upcomingAvailabilities =
        availability.where((availability) => availability.isAfter(now));

    return upcomingAvailabilities;
  }

  factory Clinic.fromJson(Map<String, dynamic> parsedJson) {
    Coordinate coordinate = Coordinate.fromJson(parsedJson['coordinate']);
    List<OpeningHours> openingHours = List<OpeningHours>();
    // parsedJson['openinghours'].forEach((k, v) {
    for (int i = 0; i < parsedJson['openinghours'].length; ++i) {
      Map value = parsedJson['openinghours'][i];
      Day _day;
      switch (value['day'].toString().toLowerCase()) {
        case 'monday':
          _day = Day.monday;
          break;
        case 'tuesday':
          _day = Day.tuesday;
          break;
        case 'wednesday':
          _day = Day.wednesday;
          break;
        case 'thursday':
          _day = Day.thursday;
          break;
        case 'friday':
          _day = Day.friday;
          break;
        case 'saturday':
          _day = Day.saturday;
          break;
        case 'sunday':
          _day = Day.sunday;
          break;
      }
      OpeningHours toAdd = OpeningHours(
        day: _day,
        hours: value['hours'].toString(),
      );
      openingHours.add(toAdd);
    }
    // });
    return Clinic(
      id: parsedJson['_id'].toString(),
      externalId: int.parse(parsedJson['external_id'].toString()),
      name: parsedJson['name'].toString(),
      owner: parsedJson['owner'].toString(),
      dentists: int.parse(parsedJson['dentists'].toString()),
      address: parsedJson['address'].toString(),
      city: parsedJson['city'].toString(),
      coordinate: coordinate,
      openingHours: openingHours,
    );
  }

  factory Clinic.fromJsonString(String data) {
    final Map parsed = json.decode(data);
    return Clinic.fromJson(parsed);
  }
}
