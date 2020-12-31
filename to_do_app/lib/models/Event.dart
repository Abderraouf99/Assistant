import 'package:flutter/material.dart';

class Event {
  //Atributes
  String _title = '';

  DateTime _dateStart = DateTime.now();
  TimeOfDay _timeOfDayStart = TimeOfDay.now();
  DateTime _dateEnd = DateTime.now();
  TimeOfDay _timeOfDayEnd = TimeOfDay.now();

  bool _toBeReminded = false;
  bool _status = false;
  //Constructor
  Event(String title, DateTime dateStart, DateTime dateEnd, TimeOfDay timeStart,
      TimeOfDay timeEnd, bool toBeReminded)
      : _title = title,
        _dateStart = dateStart,
        _dateEnd = dateEnd,
        _timeOfDayStart = timeStart,
        _timeOfDayEnd = timeEnd,
        _toBeReminded = toBeReminded;

  //Getters
  String get title => _title;

  bool get toBereminded => _toBeReminded;

  DateTime get dateStart => _dateStart;

  DateTime get dateEnd => _dateEnd;

  TimeOfDay get timeStart => _timeOfDayStart;

  TimeOfDay get timeEnds => _timeOfDayEnd;

  bool getStatus() => _status;

  //Setters
  void setTitle(String title) {
    _title = title;
  }

  set setToBeReminded(bool toBereminded) {
    _toBeReminded = toBereminded;
  }

  set setDayStarts(DateTime starts) {
    _dateStart = starts;
  }

  set setDayEnds(DateTime ends) {
    _dateEnd = ends;
  }

  set setTimeStart(TimeOfDay start) {
    _timeOfDayStart = start;
  }

  set setTimeEnds(TimeOfDay ends) {
    _timeOfDayEnd = ends;
  }

  //Methods

  void toggleReminder() {
    _toBeReminded = !_toBeReminded;
  }

  void toggleStatus() {
    _status = !_status;
  }
}
