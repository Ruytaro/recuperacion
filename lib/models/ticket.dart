import 'package:recuperacion/models/event.dart';
import 'package:recuperacion/models/user.dart';

enum TicketStatus { pending, paid, refunded, canceled }

class Ticket {
  final User _owner;
  final Event _event;
  TicketStatus _status = .pending;
  Ticket(this._owner, this._event);

  User getOwner() {
    return _owner;
  }

  Event getEvent() {
    return _event;
  }

  void setState(TicketStatus state) {
    _status = state;
  }

  TicketStatus getState() {
    return _status;
  }
}
