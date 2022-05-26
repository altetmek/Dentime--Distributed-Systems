import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationManager with ChangeNotifier {
  LocationManager() {
    Geolocator.getCurrentPosition()
        .then((newPostion) => _setCurrentPosition(newPostion));
  }

  _setCurrentPosition(Position position) {
    if (position != null) {
      _currentPosition = LatLng(position.latitude, position.longitude);
      notifyListeners();
    }
  }

  LatLng _currentPosition = LatLng(57.6990, 11.9584);

  get currentPosition => _currentPosition;
}
