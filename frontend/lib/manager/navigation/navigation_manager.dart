import 'dart:convert';

import 'package:dentime/model/clinic.dart';
import 'package:dentime/util/logger/logger.dart';
import 'package:flutter/material.dart';

class NavigationManager with ChangeNotifier {
  String _currentRoute;
  Clinic _currentDentist;
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  BuildContext _context;
  bool _isLoading = false;
  bool _isOverloaded = false;

  NavigationManager({
    currentRoute = '/',
  }) {
    this._currentRoute = currentRoute;
    this._currentDentist = currentDentist;
  }

  setIsLoading() {
    _isLoading = true;
    notifyListeners();
  }

  _setIsOverloaded(bool isOverloaded) {
    _isOverloaded = isOverloaded;
    notifyListeners();
  }

  setCurrentDentist(Clinic dentist) {
    _currentDentist = dentist;
    notifyListeners();
  }

  setMainScreenContext(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  get drawerKey => _drawerKey;
  get currentRoute => _currentRoute;
  get currentDentist => _currentDentist;
  get mainScreenContext => _context;
  get isLoading => _isLoading;
  get isOverloaded => _isOverloaded;

  void processMessage(String topic, String message) {
    final bool parsedMessage = json.decode(message);
    switch (topic) {
      case 'overload':
        _setIsOverloaded(parsedMessage);
        break;
      default:
        Log.d("No method for $topic in NavigationManager processMessage.");
        break;
    }
  }
}
