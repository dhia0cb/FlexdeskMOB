import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  int? _userId;
  String? _userName;

  int? get userId => _userId;
  String? get userName => _userName;

  void login(int userId, String userName) {
    _userId = userId;
    _userName = userName;
    notifyListeners();
  }

  void logout() {
    _userId = null;
    _userName = null;
    notifyListeners();
  }
}
