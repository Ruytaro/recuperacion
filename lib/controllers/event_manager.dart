import 'package:recuperacion/models/event.dart';

class EventManager {
  static final EventManager _manager = EventManager._internal();

  static final List<Event> _events = [];

  EventManager._internal();

  factory EventManager() {
    return _manager;
  }

  List<Event> getEvents() {
    return _events;
  }

  void addEvent(Event event) {
    for (Event ev in _events) {
      if (ev.getName() == event.getName()) {
        throw Exception('That event already exists!');
      }
    }
    _events.add(event);
  }
}
