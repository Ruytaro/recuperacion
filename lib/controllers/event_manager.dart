import 'dart:collection';

import 'package:recuperacion/models/event.dart';

class EventManager {
  static final EventManager _manager = EventManager._internal();
  static final Map<int, Event> _events = HashMap();

  EventManager._internal();

  factory EventManager() {
    return _manager;
  }

  List<Event> getEvents() {
    return _events.values.toList();
  }

  void setEvent(Event event) {
    _events[event.id] = event;
  }
}
