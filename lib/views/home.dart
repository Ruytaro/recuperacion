import 'package:flutter/material.dart';
import 'package:recuperacion/controllers/event_manager.dart';
import 'package:recuperacion/controllers/ticket_manager.dart';
import 'package:recuperacion/controllers/user_manager.dart';
import 'package:recuperacion/controllers/state_manager.dart';
import 'package:recuperacion/models/event.dart';
import 'package:recuperacion/models/ticket.dart';
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
  late EventManager em;
  late TicketManager tm;
  List<Event> _events = [];
  late User me;

  @override
  void initState() {
    super.initState();
    um = UserManager();
    sm = StateManager();
    em = EventManager();
    tm = TicketManager();
    me = um.getCurrentUser!;
    _events = em.getEventsAvalilable();
  }

  @override
  Widget build(BuildContext context) {
    if (me.isAdmin()) {
      return _buildAdmin(context);
    }
    return _buildUser(context);
  }

  Widget _buildUser(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 200),
        child: Column(
          children: [
            Text("My Events", textScaler: .linear(1.5)),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _events.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_events[index].name),
                  leading: _eventAvailability(_events[index]),
                  onTap: () => _requestTicket(_events[index]),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdmin(BuildContext context) {
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

  void _requestTicket(Event event) {
    if (event.userHasTicket(me)) {
      Notifications.showError(context, "You already have a ticket!");
      return;
    }
    if (event.isSoldOut()) {
      Notifications.showError(context, "No tickets available!");
      return;
    }
    event.sellTicket(me);
    Notifications.showMessage(context, "Ticket bought, please pay it soon");
    _updateEvents();
  }

  Icon _eventAvailability(Event event) {
    if (event.userHasTicket(me)) {
      return Icon(Icons.check);
    }
    if (event.isSoldOut()) {
      return Icon(Icons.block);
    } else {
      return Icon(Icons.shopping_basket);
    }
  }

  void _updateEvents() {
    setState(() {
      _events = em.getEventsAvalilable();
    });
  }
}
