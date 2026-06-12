import 'package:recuperacion/models/ticket.dart';
import 'package:recuperacion/models/user.dart';

enum EventStatus { planned, ongoing, finished, canceled }

class Event {
  String name;
  int eventCapacity;
  int ticketsSold = 0;
  EventStatus status = .planned;
  Event(this.name, this.eventCapacity);
  List<Ticket> tickets = [];

  void updateState(EventStatus status) {
    this.status = status;
  }

  int ticketsLeft() {
    return eventCapacity - ticketsSold;
  }

  bool sellTicket(User buyer, int amount) {
    if (amount < 1) return false;
    if (eventCapacity < amount) {
      return false;
    }
    ticketsSold += amount;
    for (int i = 0; i < amount; i++) {
      tickets.add(Ticket(buyer, this));
    }
    return true;
  }

  bool payTickets(User buyer, int amount) {
    if (amount < 1) return false;
    int pending = 0;
    for (Ticket ticket in tickets) {
      if (buyer == ticket.getOwner()) {
        if (ticket.getState() == .pending) {
          pending++;
        }
      }
    }
    if (amount > pending) {
      return false;
    }
    for (int i = 0; i < amount; i++) {
      payTicket(buyer);
    }
    return true;
  }

  void payTicket(User buyer) {
    for (Ticket ticket in tickets) {
      if (buyer == ticket.getOwner()) {
        if (ticket.getState() == .pending) {
          ticket.setState(.paid);
        }
      }
    }
    return;
  }
}
