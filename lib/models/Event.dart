class Event {
  //Atributes
  String _title;
  DateTime _dateStart;
  DateTime _dateEnd;
  bool _status = false;
  int _id;
  int _id2;

  //Constructor

  Event(String title, DateTime dateStart, DateTime dateEnd, int id, int id2)
      : _title = title,
        _dateStart = dateStart,
        _dateEnd = dateEnd,
        _id = id,
        _id2 = id2;

  //Getters
  String get title => _title;

  DateTime get dateStart => _dateStart;

  DateTime get dateEnd => _dateEnd;

  bool eventStatus() => _status;

  int id() => _id;

  set setId(int id) {
    _id = id;
  }

  int id2() => _id2;

  set setId2(int id) {
    _id2 = id;
  }

  set setTitle(String title) {
    _title = title;
  }

  set setDayStarts(DateTime starts) {
    _dateStart = starts;
  }

  set setDayEnds(DateTime ends) {
    _dateEnd = ends;
  }

  set setEventStatus(bool status) {
    _status = status;
  }

  //Methods

  void toggleStatus() {
    _status = !_status;
  }
}
