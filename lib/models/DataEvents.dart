import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/models/Event.dart';

class EventsController extends ChangeNotifier {
  //Events Controller
  List<Event> _myEvents = [];
  List<Event> _archived = [];
  List<Event> _deleted = [];

  Event _tempEvent = Event(
    '',
    DateTime.now(),
    DateTime.now().add(Duration(hours: 1)),
    0,
    0,
  );
  set archived(List<Event> events) {
    _archived = events;
    _archived.sort(
      (a, b) => a.dateStart.compareTo(b.dateStart),
    );
  }

  set deleted(List<Event> events) {
    _deleted = events;
    _deleted.sort(
      (a, b) => a.dateStart.compareTo(b.dateStart),
    );
  }

  set events(List<Event> events) {
    _myEvents = events;
    _myEvents.sort(
      (a, b) => a.dateStart.compareTo(b.dateStart),
    );
  }

  Event get tempEvent => _tempEvent;
  List<Event> get events => _myEvents;
  List<Event> get archive => _archived;
  List<Event> get removed => _deleted;
  int findNumberOfCompletedEvents() {
    int counter = 0;
    for (Event currentEvent in _myEvents) {
      if (currentEvent.eventStatus()) {
        counter++;
      }
    }
    return counter;
  }

  void toggleStatus(int index, bool isArchived) {
    (isArchived)
        ? _archived[index].toggleStatus()
        : _myEvents[index].toggleStatus();
    notifyListeners();
  }

  void addEvent(Event newEvent) {
    _myEvents.add(newEvent);
    _myEvents.sort(
      (a, b) => a.dateStart.compareTo(b.dateStart),
    );
    notifyListeners();
  }

  void moveToBin(int index, bool isArchived) {
    Event event = (isArchived) ? _archived[index] : _myEvents[index];
    _deleted.add(event);
    _deleted.sort(
      (a, b) => a.dateStart.compareTo(b.dateStart),
    );
    (isArchived) ? _archived.removeAt(index) : _myEvents.removeAt(index);
    notifyListeners();
  }

  void moveToArchive(int index) {
    Event event = _myEvents[index];
    _archived.add(event);
    _archived.sort(
      (a, b) => a.dateStart.compareTo(b.dateStart),
    );
    _myEvents.removeAt(index);
    notifyListeners();
  }

  void purgeEvent(int index){
    _deleted.removeAt(index);
    notifyListeners();
  }

  void recover(int index){
    _myEvents.add(_deleted[index]);
    _deleted.removeAt(index);
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
