import 'package:recuperacion/models/event.dart';
import 'package:recuperacion/models/user.dart';

enum TicketStatus { pending, paid, refunded, canceled }

class Ticket {
  User owner;
  Event event;
  TicketStatus _status = .pending;
  Ticket(this.owner, this.event);

  User getOwner() {
    return owner;
  }

  Event getEvent() {
    return event;
  }

  void setState(TicketStatus state) {
    _status = state;
  }

  TicketStatus getState() {
    return _status;
  }
}
