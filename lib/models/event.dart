enum EventStatus { planned, ongoing, finished, canceled }

class Event {
  String name;
  int eventCapacity;
  int ticketsSold = 0;
  EventStatus status = EventStatus.planned;
  Event(this.name, this.eventCapacity);
}
