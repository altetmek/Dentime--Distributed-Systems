import 'dart:convert';

import 'package:dentime/model/booking.dart';
import 'package:dentime/util/logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class BookingManager with ChangeNotifier {
  List<Booking> _bookings = List<Booking>();

  // Placeholder to allow notifying user when a new booking is created for them
  Booking _newBooking;

  get bookings => _bookings;
  get newBooking => _newBooking;

  removeNewBooking() {
    _newBooking = null;
    notifyListeners();
  }

  setNewBooking(newBooking) {
    _newBooking = newBooking;
    EasyLoading.dismiss();
    EasyLoading.showSuccess('Booking Successful');
    addBooking(newBooking, true);
    // EasyLoading.showInfo("Booking confirmed at ${newBooking.time.toString()}",
    //     dismissOnTap: true, duration: Duration(seconds: 20));
    // notifyListeners();
  }

  //TODO: Send to backend that it is added
  addBooking(Booking booking, bool notify) {
    bool exists = false;
    Booking existing;
    existing = _bookings.firstWhere((element) => element.id == booking.id,
        orElse: () => (Log.d('addBooking: No existing element')));
    if (existing != null) {
      if (booking == existing)
        exists = true;
      else
        _bookings.remove(existing);
    }
    if (!exists) _bookings.add(booking);
    if (notify) notifyListeners();
  }

  getBookingById(String id) {
    Booking bookingById = _bookings.firstWhere((element) => element.id == id,
        orElse: () => (Log.d('getBooking: No existing element')));
    return bookingById;
  }

  getUpcomingBookings() {
    DateTime now = DateTime.now();
    now.add(Duration(minutes: 5));
    // Log.d(bookings.length.toString());
    // Log.d(now.toString());
    final upcomingBookings =
        _bookings.where((element) => element.time.isAfter(now));

    return upcomingBookings;
  }

  getPreviousBookings() {
    DateTime now = DateTime.now();
    now.add(Duration(minutes: 5));
    final previousBookings =
        _bookings.where((element) => element.time.isBefore(now));
    return previousBookings.toList().reversed;
  }

  //TODO: Send to backend that it is deleted
  deleteBookingById(String id) {
    Booking bookingDelete = _bookings.firstWhere((element) => element.id == id,
        orElse: () => (Log.d('deleteBooking: No existing element')));

    if (bookingDelete != null) {
      _bookings.remove(bookingDelete);
      //TODO: Send to backend that it is deleted
    } else {
      Log.d('getBooking: No existing element');
    }
    notifyListeners();
  }

  void processMessage(String topic, String message) {
    String rootTopic;
    if (topic.indexOf("/") > 0) {
      rootTopic = topic.substring(0, topic.indexOf("/"));
    } else {
      rootTopic = topic;
    }
    String remainingTopic = topic.replaceFirst(rootTopic, "");
    final Map parsedMessage = json.decode(message);
    bool notify = false;
    Log.d(rootTopic);
    switch (rootTopic) {
      // One new booking created
      case "created":
        Booking tempBooking = Booking.fromJson(parsedMessage['booking']);
        setNewBooking(tempBooking);
        break;
         case "failed":
         EasyLoading.dismiss();
         EasyLoading.showError("Booking Failed");
        break;
      case "bookings":
        // for (int i = 0; i < parsed['bookings'].length; ++i) {
        //   Booking toAdd = Booking.fromJson(parsed['bookings'][i]);
        //   addBooking(toAdd, false);
        //   notify = true;
        // }
        Log.d('bookings: ');
        Log.d(message);
        break;
      default:
        Log.d('default: ');
        Log.d(message);
        processBookings(parsedJson: parsedMessage, notify: true);
        break;
    }
    if (notify) notifyListeners();
  }

  void processBookings({Map<String, dynamic> parsedJson, bool notify: false}) {
    Log.d("processBookings");
    Log.d(parsedJson.toString());
    for (int i = 0; i < parsedJson['bookings'].length; ++i) {
      Booking toAdd = Booking.fromJson(parsedJson['bookings'][i]);
      addBooking(toAdd, false);
    }
    if (notify) notifyListeners();
  }

  // TODO: Figure this out

  /*List<Booking> getSortedBooking(DateTime time) {
    // Dart internal sorting function
    _bookings.sort((a, b) {
      return a.distanceFrom(position) > b.distanceFrom(position) ? 1 : 0;
    });
    return _clinics;
  }*/

}
