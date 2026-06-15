import 'package:flutter/material.dart';
import 'package:recuperacion/controllers/event_manager.dart';
import 'package:recuperacion/controllers/user_manager.dart';
import 'package:recuperacion/controllers/state_manager.dart';
import 'package:recuperacion/models/event.dart';
import 'package:recuperacion/utils/validators.dart';
import 'package:recuperacion/widgets/buttons.dart';
import 'package:recuperacion/utils/notifications.dart';
import 'package:recuperacion/models/user.dart';
import 'package:recuperacion/widgets/forms.dart';

class EventsView extends StatefulWidget {
  const EventsView({super.key});

  @override
  _EventsViewState createState() => _EventsViewState();
}

class _EventsViewState extends State<EventsView> {
  late EventManager em;
  late StateManager sm;
  late UserManager um;
  late List<Event> events;
  late User me;

  @override
  void initState() {
    super.initState();
    em = EventManager();
    sm = StateManager();
    um = UserManager();
    me = um.getCurrentUser!;
    events = em.getEvents();
  }

  void _refreshEvents() {
    setState(() {
      events = em.getEvents(); // Refresh the list
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 200),
        child: Column(
          children: [
            Text("Manage Events", textScaler: .linear(1.5)),
            ListView.builder(
              shrinkWrap: true,
              //   physics: const NeverScrollableScrollPhysics(),
              itemCount: events.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(events[index].getName()),
                  leading: Icon(
                    (events[index].ticketsAvailable())
                        ? Icons.block
                        : Icons.person,
                  ),
                  //onTap: () => _showEditDialog(context, events[index]),
                );
              },
            ),
            ElevatedButton(
              onPressed: () {
                _showCreateDialog(context);
              },
              child: const Text("Create Event"),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            late String name;
            late String capacity;
            return AlertDialog(
              title: const Text('Create event'),
              content: Column(
                mainAxisSize: .min,
                children: [
                  myFormField((value) => name = value, "Event Name"),
                  myFormField(
                    (value) => capacity = value,
                    "Event Capacity",
                    validator: validateNumber,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                myElevatedButton(() {
                  try {
                    em.addEvent(Event(name, int.parse(capacity)));
                    Notifications.showMessage(
                      context,
                      "Event Created Succesfully",
                    );
                  } catch (e) {
                    Notifications.showError(context, e.toString());
                  }
                  Navigator.pop(context);
                  _refreshEvents();
                }, Text("Save")),
              ],
            );
          },
        );
      },
    );
  }

  /*
  void _showEditDialog(BuildContext context, Event event) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Edit User'),
              content: Column(
                mainAxisSize: .min,
                children: [
                  CheckboxListTile(
                    title: Text("Administrator"),
                    value: admin,
                    onChanged: (value) {
                      setState(() {
                        admin = value!;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: Text("Disable user"),
                    value: disabled,
                    onChanged: (value) {
                      setState(() {
                        disabled = value!;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                myElevatedButton(() {
                  setState(() {
                    try {
                      um.setUserState(name, disabled);
                      um.setUserAdmin(name, admin);
                      Notifications.showMessage(context, "User updated");
                    } catch (e) {
                      Notifications.showError(context, e.toString());
                      rethrow;
                    }
                    Navigator.pop(context);
                    _refreshEvents();
                  });
                }, Text("Save")),
              ],
            );
          },
        );
      },
    );
  }*/
}
