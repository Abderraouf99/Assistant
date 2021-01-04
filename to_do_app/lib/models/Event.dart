import 'package:flutter/material.dart';

class Event {
  //Atributes
  String _title;
  DateTime _dateStart;

  DateTime _dateEnd;

  bool _toBeReminded = false;
  bool _status = false;
  int _index;
  //Constructor

  Event(String title, DateTime dateStart, DateTime dateEnd, bool toBeReminded)
      : _title = title,
        _dateStart = dateStart,
        _dateEnd = dateEnd,
        _toBeReminded = toBeReminded;

  //Getters
  String get title => _title;

  bool get toBereminded => _toBeReminded;

  DateTime get dateStart => _dateStart;

  DateTime get dateEnd => _dateEnd;

  bool get eventStatus => _status;

  int get index => _index;

  //Setters

  set setIndex(int index) {
    _index = index;
  }

  set setTitle(String title) {
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

  set eventStatus(bool status) {
    _status = status;
  }

  //Methods

  void toggleReminder() {
    _toBeReminded = !_toBeReminded;
  }

  void toggleStatus() {
    _status = !_status;
  }
}
