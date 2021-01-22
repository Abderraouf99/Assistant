import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/models/Note.dart';

const String kNote = 'notes';
const String kArchivedNotes = 'archivedNotes';
const String kDeletedNotes = 'deletedNotes';
const String kNoteTitle = 'noteTitle';
const String kNoteText = 'noteText';
const String kNoteDate = 'noteDate';
const String kNoteKey = 'noteKey';

class NotesController extends ChangeNotifier {
  List<Note> _notes = [];
  List<Note> _archivedNotes = [];
  List<Note> _deletedNotes = [];
  final _auth = FirebaseAuth.instance;
  final _firestoreReference = FirebaseFirestore.instance.collection('users');

  List get notes => _notes;
  List get archive => _archivedNotes;
  List get deleted => _deletedNotes;

  Future<void> addNote(Note newNote) async {
    newNote.setKey = UniqueKey().toString();
    await _addNote(
      note: newNote,
      dataBase: kNote,
    );
    _notes.add(newNote);
    _notes.sort(
      (a, b) => a.date.compareTo(b.date),
    );
    notifyListeners();
  }

  Future<void> archiveNote(int index) async {
    Note note = _notes[index];
    await _archiveNoteFirebase(note);
    _notes.removeAt(index);
    _archivedNotes.add(note);
    _archivedNotes.sort(
      (a, b) => a.date.compareTo(b.date),
    );
    notifyListeners();
  }

  Future<void> unArchive(int index) async {
    Note note = _archivedNotes[index];
    _notes.add(note);
    await _unArchiveNoteFirebase(note);
    _archivedNotes.removeAt(index);
    notifyListeners();
  }

  Future<void> moveToBin(int index, bool isArchived) async {
    Note note = (isArchived) ? _archivedNotes[index] : notes[index];
    _deletedNotes.add(note);
    (isArchived) ? _archivedNotes.removeAt(index) : notes.removeAt(index);
    _deletedNotes.sort(
      (a, b) => a.date.compareTo(b.date),
    );
    await _moveNoteToBinFirebase(note, isArchived);
    notifyListeners();
  }

  Future<void> recover(int index) async {
    Note note = _deletedNotes[index];
    _notes.add(note);
    _deletedNotes.removeAt(index);
    _notes.sort(
      (a, b) => a.date.compareTo(b.date),
    );
    await _recoverNoteFirebase(note);
    notifyListeners();
  }

  Future<void> purge(int index) async {
    Note note = _deletedNotes[index];
    _deletedNotes.removeAt(index);
    await _purgeNoteFirebase(note);
    notifyListeners();
  }

  Future<void> fetchNotes() async {
    _fetchNotes(dataBase: kNote);
    _fetchNotes(dataBase: kArchivedNotes);
    _fetchNotes(dataBase: kDeletedNotes);
  }

  Future<void> _addNote({Note note, String dataBase}) async {
    await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection(dataBase)
        .add(
      {
        kNoteTitle: note.title,
        kNoteText: note.note,
        kNoteDate: note.date,
        kNoteKey: note.key
      },
    );
  }

  Future<String> _findNote({Note note, String dataBase}) async {
    String docID = '';
    var notes = await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection(dataBase)
        .get();

    for (var doc in notes.docs) {
      if (doc.data()[kNoteKey] == note.key) {
        docID = doc.id;
        break;
      }
    }
    return docID;
  }

  Future<void> _deleteNote({String docID, String dataBase}) async {
    await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection(dataBase)
        .doc(docID)
        .delete();
  }

  Future<void> _fetchNotes({String dataBase}) async {
    var notes = await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection(dataBase)
        .get();
    List<Note> notesList = [];
    for (var doc in notes.docs) {
      notesList.add(
        Note.fromParam(doc.get(kNoteText), doc.get(kNoteTitle),
            doc.get(kNoteDate).toDate(), doc.get(kNoteKey)),
      );
    }
    if (dataBase == kNote) {
      _notes = notesList;
    } else if (dataBase == kArchivedNotes) {
      _archivedNotes = notesList;
    } else {
      _deletedNotes = notesList;
    }
  }

  Future<void> _moveNoteToBinFirebase(Note note, bool isArchived) async {
    String docID = '';
    if (isArchived) {
      docID = await _findNote(
        note: note,
        dataBase: kArchivedNotes,
      );
      await _deleteNote(
        docID: docID,
        dataBase: kArchivedNotes,
      );
    } else {
      docID = await _findNote(
        dataBase: kNote,
        note: note,
      );
      await _deleteNote(
        dataBase: kNote,
        docID: docID,
      );
    }
    await _addNote(
      note: note,
      dataBase: kDeletedNotes,
    );
  }

  Future<void> _archiveNoteFirebase(Note note) async {
    String docID = await _findNote(dataBase: kNote, note: note);
    await _deleteNote(
      dataBase: kNote,
      docID: docID,
    );
    await _addNote(
      note: note,
      dataBase: kArchivedNotes,
    );
  }

  Future<void> _unArchiveNoteFirebase(Note note) async {
    String docID = await _findNote(
      note: note,
      dataBase: kArchivedNotes,
    );
    await _deleteNote(
      docID: docID,
      dataBase: kArchivedNotes,
    );
    await _addNote(note: note, dataBase: kNote);
  }

  Future<void> _purgeNoteFirebase(Note note) async {
    String docID = await _findNote(dataBase: kDeletedNotes, note: note);
    await _deleteNote(
      dataBase: kDeletedNotes,
      docID: docID,
    );
  }

  Future<void> _recoverNoteFirebase(Note note) async {
    String docID = await _findNote(dataBase: kDeletedNotes, note: note);
    await _deleteNote(
      dataBase: kDeletedNotes,
      docID: docID,
    );
    await _addNote(note: note, dataBase: kNote);
  }
}
