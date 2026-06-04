import 'package:flutter/material.dart';
import 'models/user.dart';
import 'controllers/user_manager.dart';
import 'controllers/state_manager.dart';
import 'widgets/appbar.dart';
import 'widgets/drawer.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late UserManager um;
  late StateManager sm;

  @override
  void initState() {
    super.initState();
    um = UserManager();
    sm = StateManager();
    um.register(User("admin", "admin"));
    um.register(User("Tunombre", "Tunombre"));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: GlobalKey(),
      title: 'Flutter Project 1',
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        brightness: Brightness.dark,
      ),
      home: Builder(
        builder: (context) {
          return ListenableBuilder(
            listenable: sm,
            builder: (context, child) {
              return Scaffold(
                appBar: myAppBar(),
                drawer: myDrawer(),
                body: sm.getScreen(),
              );
            },
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}
