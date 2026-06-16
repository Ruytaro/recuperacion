import 'dart:collection';

import 'package:recuperacion/models/event.dart';
import 'package:recuperacion/models/ticket.dart';
import 'package:recuperacion/models/user.dart';

class TicketManager {
  static final Map<int, Ticket> _tickets = HashMap();

  List<Ticket> getTickets() {
    return _tickets.values.toList();
  }

  List<Ticket> getEventTickets(Event event) {
    List<Ticket> tickets = [];
    for (Ticket ticket in _tickets.values) {
      if (ticket.event.isEqual(event)) {
        tickets.add(ticket);
      }
    }
    return tickets;
  }

  List<Ticket> getUserTickets(User user) {
    List<Ticket> tickets = [];
    for (Ticket ticket in _tickets.values) {
      if (ticket.owner.username == user.username) {
        tickets.add(ticket);
      }
    }
    return tickets;
  }

  void setTicket(Ticket ticket) {
    _tickets[ticket.id] = ticket;
  }
}
