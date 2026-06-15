import 'package:recuperacion/models/ticket.dart';
import 'package:recuperacion/models/user.dart';

enum EventStatus { planned, ongoing, finished, canceled }

class Event {
  final String _name;
  final int _eventCapacity;
  int _ticketsSold = 0;
  EventStatus _status = .planned;
  Event(this._name, this._eventCapacity);
  List<Ticket> tickets = [];

  void updateState(EventStatus status) {
    _status = status;
  }

  bool isSoldOut() {
    return ticketsLeft() < 1;
  }

  int ticketsLeft() {
    return _eventCapacity - _ticketsSold;
  }

  bool ticketsAvailable() {
    return !isSoldOut() && _status == .planned;
  }

  String getName() {
    return _name;
  }

  bool sellTicket(User buyer, int amount) {
    if (amount < 1) return false;
    if (_eventCapacity < amount) {
      return false;
    }
    _ticketsSold += amount;
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
