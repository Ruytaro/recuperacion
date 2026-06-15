import 'package:flutter/material.dart';
import 'package:recuperacion/controllers/event_manager.dart';
import 'package:recuperacion/models/event.dart';
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
  late EventManager em;
  @override
  void initState() {
    super.initState();
    um = UserManager();
    sm = StateManager();
    em = EventManager();
    um.register(User("admin", "admin"));
    um.register(User("Tunombre", "Tunombre"));
    um.register(User("asd", "asd"));
    um.register(User("test", "asd"));
    em.addEvent(Event("test", 4));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: GlobalKey(),
      title: 'Recuperacion',
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
