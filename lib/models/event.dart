import 'package:recuperacion/controllers/ticket_manager.dart';
import 'package:recuperacion/models/ticket.dart';
import 'package:recuperacion/models/user.dart';

enum EventStatus { planned, ongoing, finished }

class Event {
  static int _nextID = 1;
  final int id;
  final String name;
  int capacity;
  int ticketsSold = 0;
  int cost = 0;
  late String description;
  late String imgPath;
  EventStatus status = .planned;
  Event(this.name, this.capacity, this.cost, this.description) : id = _nextID++;

  bool isSoldOut() {
    return ticketsLeft() < 1;
  }

  int ticketsLeft() {
    return capacity - ticketsSold;
  }

  bool ticketsAvailable() {
    return status == .planned;
  }

  void sellTicket(User buyer) {
    ticketsSold++;
    TicketManager().setTicket(Ticket(buyer, this));
  }

  bool isEqual(Event event) {
    return id == event.id;
  }

  bool userHasTicket(User buyer) {
    for (Ticket ticket in TicketManager().getUserTickets(buyer)) {
      if (ticket.owner.equals(buyer)) {
        return true;
      }
    }
    return false;
  }
}
