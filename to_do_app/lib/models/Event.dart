class Event {
  //Atributes
  String _title;
  String _location;
  String _start;
  String _end;
  bool _toBeReminded;

  //Constructor
  Event(String title, String location, String start, String end,
      bool toBeReminded)
      : _title = title,
        _location = location,
        _start = start,
        _end = end,
        _toBeReminded = toBeReminded;

  //Getters
  String get title {
    return _title;
  }

  String get location {
    return _location;
  }

  String get start {
    return _start;
  }

  String get end {
    return _end;
  }

  bool get toBereminded {
    return _toBeReminded;
  }

  //Setters
  set setTitle(String title) {
    _title = title;
  }

  set setLocation(String location) {
    _location = location;
  }

  set setStart(String start) {
    _start = start;
  }

  set setEnd(String end) {
    _end = end;
  }

  set setToBeReminded(bool toBereminded) {
    _toBeReminded = toBereminded;
  }

  //Methods

  void toggleReminder() {
    _toBeReminded = !_toBeReminded;
  }
}
