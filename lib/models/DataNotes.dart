import 'package:flutter/material.dart';
import 'package:to_do_app/models/Note.dart';

class NotesController extends ChangeNotifier {
  List<Note> _notes = [];
  List<Note> _archivedNotes = [];
  List<Note> _deletedNotes = [];
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

  void removeAndAddToArchive(int index) {
    Note toBeMoved = _notes[index];
    _notes.removeAt(index);
    _archivedNotes.add(toBeMoved);
    _archivedNotes.sort(
      (a, b) => a.getDate.compareTo(b.getDate),
    );
    notifyListeners();
  }

  void removeAndAddTobin(int index) {
    Note toBeDeleted = _notes[index];
    _notes.removeAt(index);
    _deletedNotes.add(toBeDeleted);
    _deletedNotes.sort(
      (a, b) => a.getDate.compareTo(b.getDate),
    );
    notifyListeners();
  }
}
