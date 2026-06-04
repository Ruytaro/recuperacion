import 'package:flutter/material.dart';
import 'package:recuperacion/controllers/state_manager.dart';
import 'package:recuperacion/widgets/buttons.dart';

class LogoutView extends StatefulWidget {
  @override
  _LogoutViewState createState() => _LogoutViewState();
}

class _LogoutViewState extends State<LogoutView> {
  late StateManager sm;

  @override
  void initState() {
    super.initState();
    sm = StateManager();
  }

  void _handleGoToLogin() {
    sm.set("login");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Your session was terminated!"),
        Center(child: myElevatedButton(_handleGoToLogin, Text("Go to login"))),
      ],
    );
  }
}
