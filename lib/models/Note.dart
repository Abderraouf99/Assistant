class Note {
  String _note;
  String _title;
  DateTime _date;
  String _key;
  Note() {
    this._date = DateTime.now();
    this._key = '';
    this._title = '';
    this._note = '';
  }
  Note.fromParam(String note, String title, DateTime date, String key)
      : _note = note,
        _title = title,
        _date = date,
        _key = key;

  //Setters
  set setNote(String note) {
    _note = note;
  }

  set setTitle(String title) {
    _title = title;
  }

  set setDate(DateTime date) {
    _date = date;
  }

  set setKey(String key) {
    _key = key;
  }

  //Getters
  get note => _note;
  get title => _title;
  get date => _date;
  get key => _key;
}
