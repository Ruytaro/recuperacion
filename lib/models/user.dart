import 'package:recuperacion/models/ticket.dart';

class User {
  String username;
  String _password;
  String avatar;
  int age;
  String pronoum;
  String province;
  bool _admin = false;
  bool _disabled = false;

  List<Ticket> tickets = [];

  User(
    this.username,
    this._password, {
    this.avatar = "images/avatar.png",
    this.age = 33,
    this.pronoum = "Any",
    this.province = "Huesca",
  });

  bool checkLogin(String name, String pass) {
    if (username == name && _disabled == false) {
      return _isPasswordRight(pass);
    }
    return false;
  }

  bool _isPasswordRight(String pass) {
    return pass == _password;
  }

  String getPassword() {
    return _password;
  }

  void setAdmin(bool admin) {
    _admin = admin;
  }

  void setDisabled(bool disabled) {
    _disabled = disabled;
  }

  bool isAdmin() {
    return _admin;
  }

  bool equals(User user) {
    return username == user.username;
  }

  bool isDisabled() {
    return _disabled;
  }
}
