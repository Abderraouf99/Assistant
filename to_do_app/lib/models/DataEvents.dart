import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/models/Event.dart';
import 'package:intl/intl.dart';

class EventsController extends ChangeNotifier {
  //Events Controller
  List<Event> _myEvents = [];
  DateTime _selectedStartingDate = DateTime.now();
  TimeOfDay _timeOfDay = TimeOfDay.now();

  DateTime _selectedEndDate = DateTime.now();
  TimeOfDay _timeOfDayEnd = TimeOfDay.now();

  String _title;

  List<Event> get events => _myEvents;

  int findNumberOfCompletedEvents() {
    int counter = 0;
    for (Event currentEvent in _myEvents) {
      if (currentEvent.getStatus()) {
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
    notifyListeners();
  }

  void removeEvent(int index) {
    _myEvents.removeAt(index);
    notifyListeners();
  }

  void setEndDate(DateTime selected) {
    _selectedEndDate = selected;
    notifyListeners();
  }

  void setTimeOfEnd(TimeOfDay selected) {
    _timeOfDayEnd = selected;
    notifyListeners();
  }

  void setTitle(String title) {
    _title = title;
    notifyListeners();
  }

  String getTitle() {
    return _title;
  }

  TimeOfDay getTimeofDayEnd() {
    return _timeOfDayEnd;
  }

  DateTime getSelectedEndDate() {
    return _selectedEndDate;
  }

  TimeOfDay getSelectedTime() {
    return _timeOfDay;
  }

  void setTime(TimeOfDay selected) {
    _timeOfDay = selected;
    notifyListeners();
  }

  void setStartDate(DateTime selected) {
    _selectedStartingDate = selected;
    notifyListeners();
  }

  DateTime getStartDate() {
    return _selectedStartingDate;
  }
}
