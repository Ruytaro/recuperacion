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
            onPressed: () => sm.set("home"),
            child: Text("Home screen"),
          ),
          ElevatedButton(
            onPressed: () {
              sm.set("users");
            },
            child: Text("Manage Users"),
          ),
          ElevatedButton(
            onPressed: () {
              sm.set("events");
            },
            child: Text("Manage Events"),
          ),
          ElevatedButton(
            onPressed: () {
              sm.set("register");
            },
            child: Text("Register new user"),
          ),
          ElevatedButton(
            onPressed: () {
              um.logOut();
              sm.set("logout");
            },
            child: Text("Log Out"),
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
