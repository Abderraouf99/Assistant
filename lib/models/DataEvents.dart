import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/models/Event.dart';

class EventsController extends ChangeNotifier {
  //Events Controller
  List<Event> _myEvents = [];
  Event _tempEvent = Event(
    '',
    DateTime.now(),
    DateTime.now(),
    0,
  );

  set events(List<Event> events) {
    _myEvents = events;
    _myEvents.sort(
      (a, b) => a.dateStart.compareTo(b.dateStart),
    );
  }

  Event get tempEvent => _tempEvent;
  List<Event> get events => _myEvents;

  int findNumberOfCompletedEvents() {
    int counter = 0;
    for (Event currentEvent in _myEvents) {
      if (currentEvent.eventStatus()) {
        counter++;
      }
    }
    return counter;
  }

  void toggleStatus(int index) {
    _myEvents[index].toggleStatus();
    notifyListeners();
  }

  void addEvent(Event newEvent) {
    _myEvents.add(newEvent);
    _myEvents.sort(
      (a, b) => a.dateStart.compareTo(b.dateStart),
    );
    notifyListeners();
  }

  void removeEvent(int index) {
    _myEvents.removeAt(index);
    notifyListeners();
  }

  void setEndDate(DateTime selected) {
    _tempEvent.setDayEnds = selected;
    notifyListeners();
  }

  void setTitle(String title) {
    _tempEvent.setTitle = title;
    notifyListeners();
  }

  String getTitle() {
    return _tempEvent.title;
  }

  DateTime getEndDate() {
    return _tempEvent.dateEnd;
  }

  void setStartDate(DateTime selected) {
    _tempEvent.setDayStarts = selected;
    notifyListeners();
  }

  DateTime getStartDate() {
    return _tempEvent.dateStart;
  }
}
