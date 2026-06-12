import 'package:flutter/material.dart';
import 'package:recuperacion/views/login.dart';
import 'package:recuperacion/views/logout.dart';
import 'package:recuperacion/views/home.dart';
import 'package:recuperacion/views/users.dart';
import 'package:recuperacion/views/register.dart';
import 'package:recuperacion/views/events.dart';

class StateManager extends ChangeNotifier {
  static final StateManager _manager = StateManager._internal();
  StateManager._internal();

  factory StateManager() {
    return _manager;
  }

  String _screen = "login";

  void set(String newScreen) {
    _screen = newScreen;
    notifyListeners();
  }

  ScaffoldMessenger messenger = ScaffoldMessenger(child: Text("data"));

  Widget? getScreen() {
    switch (_screen) {
      case "users":
        return SingleChildScrollView(child: UsersView());
      case "events":
        return SingleChildScrollView(child: EventsView());
      case "home":
        return SingleChildScrollView(child: HomeView());
      case "login":
        return SingleChildScrollView(child: LoginView());
      case "logout":
        return SingleChildScrollView(child: LogoutView());
      case "register":
        return SingleChildScrollView(child: RegisterView());
      default:
        return SingleChildScrollView(child: LoginView());
    }
  }
}
