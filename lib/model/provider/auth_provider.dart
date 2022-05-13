import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:pappi_store/model/http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationProvider with ChangeNotifier {
  String? _authToken;
  DateTime? _tokenExpiryDate;
  String? _userId;
  Timer? _authTimer;

  bool get authStatus => token != null;

  String? get token {
    if (_tokenExpiryDate != null &&
        _tokenExpiryDate!.isAfter(DateTime.now()) &&
        _authToken != null) {
      return _authToken!;
    }
    return null;
  }

  String get userId {
    if (_userId == null) {
      return '';
    }
    return _userId!;
  }

  Future<void> _userAuthentication(
      String email, String password, String urlSegment) async {
    final url = Uri.parse(
      'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyB16mBxWjlwEyZK3Q1iUQQokDQD-rnbS44',
    );
    try {
      final response = await http.post(
        url,
        body: jsonEncode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );
      final authResponse = jsonDecode(response.body);
      if (authResponse['error'] != null) {
        throw HttpExceptionError(
          errorMessage: authResponse['error']['message'],
        );
      }
      _authToken = authResponse['idToken'];
      _userId = authResponse['localId'];
      _tokenExpiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            authResponse['expiresIn'],
          ),
        ),
      );
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userDetails = jsonEncode({
        'token': _authToken,
        'userId': _userId,
        'expiryDate': _tokenExpiryDate!.toIso8601String(),
      });
      prefs.setString('userDetails', userDetails);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _userAuthentication(email, password, 'signUp');
  }

  Future<void> logIn(String email, String password) async {
    return _userAuthentication(email, password, 'signInWithPassword');
  }

  Future<bool> autoLogIn() async {
    final loginPrefs = await SharedPreferences.getInstance();
    if (!loginPrefs.containsKey('userDetails')) {
      return false;
    }
    final getUserData =
        jsonDecode(loginPrefs.getString('userDetails').toString())
            as Map<String, dynamic>;
    final expiryDate = DateTime.parse(getUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _authToken = getUserData['token'];
    _userId = getUserData['userId'];
    _tokenExpiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    _authToken = null;
    _userId = null;
    _tokenExpiryDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final logPrefs = await SharedPreferences.getInstance();
    logPrefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final expiryTime = _tokenExpiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(
      Duration(seconds: expiryTime),
      logout,
    );
  }
}
