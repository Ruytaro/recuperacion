import 'package:flutter/material.dart';
import 'package:recuperacion/controllers/event_manager.dart';
import 'package:recuperacion/controllers/user_manager.dart';
import 'package:recuperacion/controllers/state_manager.dart';
import 'package:recuperacion/models/event.dart';
import 'package:recuperacion/widgets/buttons.dart';
import 'package:recuperacion/utils/notifications.dart';
import 'package:recuperacion/models/user.dart';

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
  }

  void _refreshEvents() {
    setState(() {
      events = em.getEvents(); // Refresh the list
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> users = um.getUsers();
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 200),
        child: Column(
          children: [
            Text("Manage Users", textScaler: .linear(1.5)),
            ListView.builder(
              shrinkWrap: true,
              //   physics: const NeverScrollableScrollPhysics(),
              itemCount: users.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(users[index]),
                  leading: Icon(
                    (um.userIsAdmin(users[index]))
                        ? Icons.shield
                        : Icons.person,
                    color: (um.userIsDisabled(users[index]))
                        ? Colors.red
                        : Colors.green,
                  ),
                  onTap: () => _showEditDialog(context, users[index]),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, String name) {
    User target = um.getUser(name);
    bool admin = um.userIsAdmin(name);
    bool disabled = target.isDisabled();
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
  }
}
