import 'package:devlite_flutter/everything.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;

  String? _authToken;

  AuthService._internal();

  void setAuthToken(String? token) {
    _authToken = token;
    mozPrint('Auth token set (in-memory).', 'AUTH', 'SET');
  }

  String? getAuthToken() {
    mozPrint('Auth token retrieved (in-memory).', 'AUTH', 'GET');
    return _authToken;
  }

  void clearAuthToken() {
    _authToken = null;
    mozPrint('Auth token cleared (in-memory).', 'AUTH', 'CLEAR');
  }
}
