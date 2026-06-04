import 'package:recuperacion/models/event.dart';

class User {
  String username;
  String password;
  String avatar;
  int age;
  String pronoum;
  String province;
  bool admin;
  bool disabled;

  List<Event> registered = List.empty(growable: true);

  User(
    this.username,
    this.password, {
    this.avatar = "images/avatar.png",
    this.age = 33,
    this.pronoum = "Any",
    this.province = "Huesca",
    this.admin = false,
    this.disabled = false,
  });

  bool checkLogin(String name, String pass) {
    if (username == name) {
      return _isPasswordRight(pass);
    }
    return false;
  }

  bool _isPasswordRight(String pass) {
    return pass == password;
  }
}
