import 'package:flutter/material.dart';
import 'package:to_do_app/models/Note.dart';

class NotesController extends ChangeNotifier {
  List<Note> _notes = [];
  String note;
  String title;
  DateTime date = DateTime.now();

  void addNote(Note newNote) {
    _notes.add(newNote);
    _notes.sort(
      (a, b) => a.getDate.compareTo(b.getDate),
    );
    notifyListeners();
  }

  List get notes => _notes;
}
