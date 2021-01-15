class Note {
  String _note;
  String _title;
  DateTime _date;
  Note(String note, String title, DateTime date)
      : _note = note,
        _title = title,
        _date = date;

  //Setters
  set note(String note) {
    _note = note;
  }

  set title(String title) {
    _title = title;
  }

  set date(DateTime date) {
    _date = date;
  }

  //Getters
  get getNote => _note;
  get getTitle => _title;
  get getDate => _date;
}
