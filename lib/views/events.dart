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
      events = em.getEvents();
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
              itemCount: events.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(events[index].name),
                  leading: Icon(
                    (events[index].ticketsAvailable())
                        ? Icons.check
                        : Icons.block,
                  ),
                  onTap: () => _showEditDialog(context, events[index]),
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
                    em.setEvent(
                      Event(name, int.parse(capacity), 22, "placeholder"),
                    );
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

  void _showEditDialog(BuildContext context, Event event) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Editing event ${event.name}'),
              content: Column(
                mainAxisSize: .min,
                children: [
                  DropdownButtonFormField<EventStatus>(
                    initialValue: event.status,
                    items: EventStatus.values.map((EventStatus value) {
                      String displayName = value.toString().split('.').last;
                      return DropdownMenuItem<EventStatus>(
                        value: value,
                        child: Row(children: [Text(displayName)]),
                      );
                    }).toList(),
                    onChanged: (value) => event.status = value!,
                  ),
                  myFormField(
                    (value) => event.capacity = value,
                    "Event capacity: ${event.capacity}",
                    validator: isNumber,
                  ),
                  myFormField(
                    (value) => event.cost = value,
                    "Ticket cost:  ${event.cost}",
                    validator: isNumber,
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
                      em.setEvent(event);
                      Notifications.showMessage(context, "Event updated");
                    } catch (e) {
                      Notifications.showError(context, e.toString());
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
  }

  void updateEvent(String? value) {}
}
