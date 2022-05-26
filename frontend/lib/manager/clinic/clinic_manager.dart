import 'dart:convert';

import 'package:dentime/model/clinic.dart';
import 'package:dentime/util/date_util/date_util.dart';
import 'package:dentime/util/logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ClinicManager with ChangeNotifier {
  List<Clinic> _clinics = List<Clinic>();

  get clinics => _clinics;

  addClinic(Clinic clinic, bool notify) {
    bool exists = false;
    Clinic existing;
    existing = _clinics.firstWhere((element) => element.id == clinic.id,
        orElse: () => (Log.d('addClinic: No existing element')));
    if (existing != null) {
      if (clinic == existing)
        exists = true;
      else
        _clinics.remove(existing);
    }
    if (!exists) _clinics.add(clinic);
    if (notify) notifyListeners();
  }

  Clinic getClinicById(String id) {
    Clinic clinicById = _clinics.firstWhere((element) => element.id == id,
        orElse: () => (Log.d('getClinic: No existing element')));
    return clinicById;
  }

  void processMessage(String topic, String message) {
    String rootTopic;
    if (topic.indexOf("/") > 0) {
      rootTopic = topic.substring(0, topic.indexOf("/"));
    } else {
      rootTopic = topic;
    }

    String remainingTopic = topic.replaceFirst(rootTopic + "/", "");

    final Map parsed = json.decode(message);

    switch (rootTopic) {
      case "availability":
        String clinicID = remainingTopic;
        Clinic clinic = getClinicById(clinicID);
        clinic.availability.removeRange(0, clinic.availability.length);
        for (int i = 0; i < parsed['availableTimes'].length; ++i) {
          DateTime toAdd = DateUtil.parseDateString(
              timeString: parsed['availableTimes'][i].toString());
          clinic.availability.add(toAdd);
        }
        notifyListeners();
        break;
      default:
        bool notify = false;
        for (int i = 0; i < parsed['clinics'].length; ++i) {
          Clinic toAdd = Clinic.fromJson(parsed['clinics'][i]);
          addClinic(toAdd, false);
          notify = true;
        }
        if (notify) notifyListeners();
        break;
    }
  }

  List<Clinic> getSortedClinics(LatLng position) {
    // Dart internal sorting function
    _clinics.sort((a, b) {
      return a.distanceFrom(position) > b.distanceFrom(position) ? 1 : 0;
    });
    return _clinics;
  }
}
