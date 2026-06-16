import 'package:flutter/material.dart';
import 'package:recuperacion/controllers/user_manager.dart';
import 'package:recuperacion/controllers/state_manager.dart';
import 'package:recuperacion/widgets/buttons.dart';
import 'package:recuperacion/utils/notifications.dart';
import 'package:recuperacion/models/user.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  late UserManager um;
  late StateManager sm;
  late User me;

  @override
  void initState() {
    super.initState();
    um = UserManager();
    sm = StateManager();
    me = um.getCurrentUser!;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text("Welcome ${me.username}"),
          myElevatedButton(() {
            Notifications.showMessage(context, "Logout");
            um.logOut();
            sm.set("logout");
          }, Text("Logout!")),
        ],
      ),
    );
  }
}
