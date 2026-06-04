import 'package:flutter/material.dart';
import 'package:recuperacion/controllers/user_manager.dart';
import 'package:recuperacion/controllers/state_manager.dart';

Drawer? myDrawer() {
  UserManager um = UserManager();
  StateManager sm = StateManager();
  if (UserManager().getCurrentUser == null) {
    return null;
  }
  if (um.isAdmin()) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(child: Text("Main Menu")),
          ElevatedButton(
            onPressed: () {
              sm.set("register");
            },
            child: Text("Register new user"),
          ),
        ],
      ),
    );
  } else {
    return Drawer(
      child: Column(children: [DrawerHeader(child: Text("User menu"))]),
    );
  }
}
