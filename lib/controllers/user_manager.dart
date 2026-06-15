import 'dart:collection';

import '../models/user.dart';

class UserManager {
  static const String adminUser = "admin";

  static final Map<String, User> _users = HashMap();
  static User? _currentUser;
  User? get getCurrentUser => _currentUser;

  bool isLogged() {
    return _currentUser != null;
  }

  bool isAdmin() {
    if (_currentUser == null) {
      return false;
    }
    if (_currentUser?.username == adminUser) {
      return true;
    }
    return _currentUser!.isAdmin();
  }

  bool userIsAdmin(String name) {
    if (name == adminUser) {
      return true;
    }
    User? user = _users[name];
    if (user == null) {
      return false;
    }
    return user.isAdmin();
  }

  bool register(User user) {
    final name = user.username;
    if (_users.containsKey(name)) {
      return false;
    }
    _users[name] = user;
    return true;
  }

  void logOut() {
    _currentUser = null;
  }

  bool loginFailed = false;

  bool hasFailedLogins() {
    return loginFailed;
  }

  String? recoverPassword(String username) {
    return _users[username]?.getPassword();
  }

  bool logIn(String username, String password) {
    User? user = _users[username];
    if (user == null) {
      loginFailed = true;
      return false;
    }
    if (user.checkLogin(username, password)) {
      _currentUser = user;
      loginFailed = false;
      return true;
    }
    loginFailed = true;
    return false;
  }

  void deleteUser(String username) {
    if (username == adminUser || username == _currentUser?.username) {
      throw Exception('User can\'t be deleted!');
    }
    var user = _users.remove(username);
    if (user == null) {
      throw Exception('User not found!');
    }
  }

  void setUserState(String username, bool disabled) {
    if (username == adminUser) {
      throw Exception('User can\'t be modified!');
    }
    if (!_users.containsKey(username)) {
      throw Exception('User not found!');
    }
    if (username == _currentUser?.username) {
      throw Exception('You can\'t modify your own user!');
    }
    _users[username]!.setDisabled(disabled);
  }

  void setUserAdmin(String username, bool admin) {
    if (username == adminUser) {
      throw Exception('User can\'t be modified!');
    }
    if (!_users.containsKey(username)) {
      throw Exception('User not found!');
    }
    if (username == _currentUser?.username) {
      throw Exception('You can\'t modify your own user!');
    }
    _users[username]!.setAdmin(admin);
  }

  List<String> getUsers() {
    return _users.keys.toList(growable: false);
  }

  User getUser(String id) {
    return _users[id]!;
  }

  bool userIsDisabled(String name) {
    if (name == adminUser) {
      return false;
    }
    User? user = _users[name];
    if (user == null) {
      return true;
    }
    return user.isDisabled();
  }
}
