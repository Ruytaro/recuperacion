import 'dart:collection';
import 'package:flutter/material.dart';

import '../models/user.dart';

class UserManager {
  static final UserManager _manager = UserManager._internal();

  final Map<String, User> _users = HashMap();
  User? _currentUser;
  User? get getCurrentUser => _currentUser;

  UserManager._internal();

  factory UserManager() {
    return _manager;
  }

  bool isLogged() {
    return _currentUser != null;
  }

  bool isAdmin() {
    if (_currentUser == null) {
      return false;
    }
    if (_currentUser?.username == "admin") {
      return true;
    }
    return _currentUser!.admin;
  }

  bool register(User user) {
    final name = user.username;
    if (_users.containsKey(name)) {
      return false;
    }
    _users[name] = user;
    _currentUser = user;
    return true;
  }

  void logOut() {
    _currentUser = null;
  }

  bool loginFailed = false;

  bool hasFailedLogins() {
    return loginFailed;
  }

  Widget recoverPassword(String? username) {
    var pass = _users[username]?.password;
    if (pass != null) {
      return Text("It's password is: $pass");
    }
    return Text("User not found");
  }

  bool logIn(String username, String password) {
    if (!_users.containsKey(username)) {
      loginFailed = true;
      return false;
    }
    User user = _users[username]!;
    if (user.checkLogin(username, password)) {
      _currentUser = user;
      loginFailed = false;
      return true;
    }
    loginFailed = true;
    return false;
  }

  bool deleteUser(String username) {
    if (username == "admin" || username == _currentUser?.username) {
      return false;
    }
    var user = _users.remove(username);
    if (user == null) {
      return false;
    }
    return true;
  }

  bool toggleUser(String username) {
    if (username == "admin" || username == _currentUser?.username) {
      return false;
    }
    if (!_users.containsKey(username)) {
      return false;
    }
    _users[username]!.disabled = !_users[username]!.disabled;
    return true;
  }
}
