import 'package:flutter/material.dart';
import 'package:to_do_app/models/Note.dart';

class NotesController extends ChangeNotifier {
  List<Note> _notes = [];
  List<Note> _archivedNotes = [];
  List<Note> _deletedNotes = [];
  String note = '';
  String title = '';
  DateTime date = DateTime.now();

  void addNote(Note newNote) {
    _notes.add(newNote);
    _notes.sort(
      (a, b) => a.getDate.compareTo(b.getDate),
    );
    notifyListeners();
  }

  void unArchive(int index) {
    _notes.add(_archivedNotes[index]);
    _archivedNotes.removeAt(index);
    notifyListeners();
  }

  List get notes => _notes;
  List get archieve => _archivedNotes;
  List get deleted => _deletedNotes;

  void removeAndAddToArchive(int index) {
    Note toBeMoved = _notes[index];
    _notes.removeAt(index);
    _archivedNotes.add(toBeMoved);
    _archivedNotes.sort(
      (a, b) => a.getDate.compareTo(b.getDate),
    );
    notifyListeners();
  }

  void removeAndAddTobin(int index, bool isArchived) {
    Note note;
    if (isArchived) {
      note = _archivedNotes[index];
      _archivedNotes.removeAt(index);
    } else {
      note = _notes[index];
      _notes.removeAt(index);
    }

    _deletedNotes.add(note);
    _deletedNotes.sort(
      (a, b) => a.getDate.compareTo(b.getDate),
    );
    notifyListeners();
  }

  void setNote(List<Note> notes) {
    _notes = notes;
  }

  void setArchivedNotes(List<Note> notes) {
    _archivedNotes = notes;
  }

  void setDeletedNotes(List<Note> notes) {
    _deletedNotes = notes;
  }
}
