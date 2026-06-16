import 'package:flutter/material.dart';
import 'package:recuperacion/controllers/event_manager.dart';
import 'package:recuperacion/controllers/ticket_manager.dart';
import 'package:recuperacion/controllers/user_manager.dart';
import 'package:recuperacion/controllers/state_manager.dart';
import 'package:recuperacion/models/event.dart';
import 'package:recuperacion/models/ticket.dart';
import 'package:recuperacion/utils/validators.dart';
import 'package:recuperacion/widgets/buttons.dart';
import 'package:recuperacion/utils/notifications.dart';
import 'package:recuperacion/models/user.dart';
import 'package:recuperacion/widgets/forms.dart';

class TicketsView extends StatefulWidget {
  const TicketsView({super.key});

  @override
  _TicketsViewState createState() => _TicketsViewState();
}

class _TicketsViewState extends State<TicketsView> {
  late TicketManager tm;
  late EventManager em;
  late StateManager sm;
  late UserManager um;
  late List<Ticket> tickets;
  late User me;

  @override
  void initState() {
    super.initState();
    tm = TicketManager();
    em = EventManager();
    sm = StateManager();
    um = UserManager();
    me = um.getCurrentUser!;
    tickets = tm.getTickets();
  }

  void _refreshEvents() {
    setState(() {
      tickets = tm.getTickets();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 200),
        child: Column(
          children: [
            Text("Manage Tickets", textScaler: .linear(1.5)),
            ListView.builder(
              shrinkWrap: true,
              itemCount: tickets.length,
              itemBuilder: (context, index) {
                Ticket t = tickets[index];
                return ListTile(
                  title: Text(
                    "${t.event.name} ${t.status.name} ${t.owner.username}",
                  ),
                  leading: _getStatus(t),
                  onTap: () => _showEditDialog(context, tickets[index]),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, Ticket ticket) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            TicketStatus status = ticket.status;
            return AlertDialog(
              title: Text('Editing event'),
              content: Column(
                mainAxisSize: .min,
                children: [
                  DropdownButtonFormField<TicketStatus>(
                    initialValue: ticket.status,
                    items: TicketStatus.values.map((TicketStatus value) {
                      String displayName = value.toString().split('.').last;
                      return DropdownMenuItem<TicketStatus>(
                        value: value,
                        child: Row(children: [Text(displayName)]),
                      );
                    }).toList(),
                    onChanged: (value) => status = value!,
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
                      tm.setTicket(ticket);
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

  Widget? _getStatus(Ticket t) {
    switch (t.status) {
      case TicketStatus.pending:
        return Icon(Icons.euro, color: Colors.red);
      case TicketStatus.paid:
        return Icon(Icons.euro, color: Colors.green);
      case TicketStatus.canceled:
        return Icon(Icons.block, color: Colors.red);
      case TicketStatus.assisted:
        return Icon(Icons.check, color: Colors.green);
    }
  }
}
