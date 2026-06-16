import 'package:recuperacion/models/event.dart';
import 'package:recuperacion/models/user.dart';

enum TicketStatus { pending, paid, assisted, canceled }

class Ticket {
  static int _nextID = 1;
  final int id;
  final User owner;
  final Event event;
  TicketStatus status = .pending;
  Ticket(this.owner, this.event) : id = _nextID++;
}
