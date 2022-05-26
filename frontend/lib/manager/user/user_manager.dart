import 'dart:convert';

import 'package:dentime/model/user.dart';
import 'package:flutter/material.dart';

class UserManager with ChangeNotifier {
  User _currentUser;

  UserManager() {
    // TODO: Use real user information :)
    User TEMPORARYUSER = User(id: "5fd92c34ff6f9a6e44707c06");
    _currentUser = TEMPORARYUSER;
  }

  get currentUser => _currentUser;

  //TODO: Send to backend that it is added
  setUser(User currentUser, bool notify) {
    _currentUser = currentUser;
    if (notify) notifyListeners();
  }

  //TODO: Figure out how to pick the correct user
  void processMessage(String topic, String message) {
    final Map parsed = json.decode(message);
    bool notify = false;
    for (int i = 0; i < parsed['user'].length; ++i) {
      User currentUser = User.fromJson(parsed['user'][i]);
      setUser(currentUser, false);
      notify = true;
    }
    if (notify) notifyListeners();
  }
}
