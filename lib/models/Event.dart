class Event {
  String _title;
  DateTime _dateStart;
  DateTime _dateEnd;
  bool _status = false;
  DateTime _reminderTime;
  String _key;
  int _id;
  //Constructor
  Event() {
    this._title = '';
    this._dateStart = DateTime.now();
    this._dateEnd = DateTime.now().add(
      Duration(hours: 1),
    );
    this._key = '';
    this._id = 0;
  }
  Event.fromParam(
      String title, DateTime dateStart, DateTime dateEnd, String key, int id)
      : _title = title,
        _dateStart = dateStart,
        _dateEnd = dateEnd,
        _id = id,
        _key = key;

  //Getters
  String get title => _title;
  DateTime get dateStart => _dateStart;
  DateTime get dateEnd => _dateEnd;
  String get key => _key;
  bool eventStatus() => _status;
  DateTime get reminder => _reminderTime;

  int get id => _id;

  set setTitle(String title) {
    _title = title;
  }

  set setID(int id) {
    _id = id;
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

  set setReminder(DateTime reminderTime) {
    _reminderTime = reminderTime;
  }

  set setKey(String key) {
    _key = key;
  }

  //Methods

  void toggleStatus() {
    _status = !_status;
  }
}
