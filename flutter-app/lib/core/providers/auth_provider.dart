import 'package:flutter/foundation.dart';

class AuthProvider with ChangeNotifier {
  String? _userId;
  String? _userName;
  String? _userEmail;
  bool _isAuthenticated = false;

  String? get userId => _userId;
  String? get userName => _userName;
  String? get userEmail => _userEmail;
  bool get isAuthenticated => _isAuthenticated;

  Future<bool> login(String email, String password) async {
    // API call to login
    // For now, mock implementation
    await Future.delayed(const Duration(seconds: 1));
    _isAuthenticated = true;
    _userEmail = email;
    notifyListeners();
    return true;
  }

  Future<bool> register(String name, String email, String password) async {
    // API call to register
    await Future.delayed(const Duration(seconds: 1));
    _isAuthenticated = true;
    _userName = name;
    _userEmail = email;
    notifyListeners();
    return true;
  }

  void logout() {
    _userId = null;
    _userName = null;
    _userEmail = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}

