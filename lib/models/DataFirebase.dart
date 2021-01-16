import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/models/DataTask.dart';
import 'package:to_do_app/models/Note.dart';
import 'Tasks.dart';
import 'Event.dart';

class FirebaseController extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _firestoreReference = FirebaseFirestore.instance.collection('users');
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void toggleIsLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }

  FirebaseAuth getAuthInstance() {
    return _auth;
  }

  void createNewUserDocument() async {
    await _firestoreReference.doc('${_auth.currentUser.email}').set(
      {'id': '${_auth.currentUser.email}'},
    );
  }

  /// ***********************************Task related actions**************************************/

  final String kArchivedTasks = 'archiveTask';
  final String kTask = 'tasks';
  final String kdeletedTasks = "binTasks";

  Future<void> addTask(Task task) async {
    await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection(kTask)
        .add(
      {
        'taskText': task.getTask(),
        'taskStatus': task.getState(),
      },
    );
  }

  Future<String> _findInArchiveDataBase(Task task) async {
    String docID;
    var archivedTasks = await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection(kArchivedTasks)
        .get();
    for (var document in archivedTasks.docs) {
      if (document.data()['taskText'] == task.getTask()) {
        docID = document.id;
        break;
      }
    }
    return docID;
  }

  Future<String> _findInTaskDataBase(Task task) async {
    String docID;
    var tasks = await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection(kTask)
        .get();
    for (var document in tasks.docs) {
      if (document.data()['taskText'] == task.getTask()) {
        docID = document.id;
        break;
      }
    }
    return docID;
  }

  Future<String> _findInTaskBinDataBase(Task task) async {
    String docID = '';
    var tasks = await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection(kdeletedTasks)
        .get();

    for (var doc in tasks.docs) {
      if (doc.data()['taskText'] == task.getTask()) {
        docID = doc.id;
        break;
      }
    }
    return docID;
  }

  Future<void> _deleteFromArchive(String docID) async {
    await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection(kArchivedTasks)
        .doc(docID)
        .delete();
  }

  Future<void> _deleteFromBin(String docID) async {
    await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection(kdeletedTasks)
        .doc(docID)
        .delete();
  }

  Future<void> _deleteFromTasks(String docID) async {
    await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection(kTask)
        .doc(docID)
        .delete();
  }

  Future<void> _addToBin(Task task) async {
    await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection(kdeletedTasks)
        .add(
      {
        'taskText': task.getTask(),
        'taskStatus': task.getState(),
      },
    );
  }

  Future<void> _addToArchive(Task task) async {
    await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection(kArchivedTasks)
        .add(
      {
        'taskText': task.getTask(),
        'taskStatus': task.getState(),
      },
    );
  }

  Future<void> _fetchMainTasks(BuildContext context) async {
    var task = await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection(kTask)
        .get();
    List<Task> taskList = [];
    for (var doc in task.docs) {
      taskList.add(
        Task(
          task: doc.get('taskText'),
          status: doc.get('taskStatus'),
        ),
      );
    }
    Provider.of<TaskController>(context, listen: false).setTasks(taskList);
  }

  Future<void> _fetchArchivedTasks(BuildContext context) async {
    var archivedTasks = await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection(kArchivedTasks)
        .get();
    List<Task> archive = [];
    for (var doc in archivedTasks.docs) {
      archive.add(
        Task(
          task: doc.get('taskText'),
          status: doc.get('taskStatus'),
        ),
      );
    }
    Provider.of<TaskController>(context, listen: false).setArchived(archive);
  }

  Future<void> _fetchDeletedTasks(BuildContext context) async {
    var deletedTasks = await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection(kdeletedTasks)
        .get();
    List<Task> deleted = [];
    for (var doc in deletedTasks.docs) {
      deleted.add(
        Task(
          task: doc.get('taskText'),
          status: doc.get('taskStatus'),
        ),
      );
    }
    Provider.of<TaskController>(context, listen: false).setDeleted(deleted);
  }

  Future<void> moveTobin(Task task, bool isArchived) async {
    String docID = '';
    if (isArchived) {
      docID = await _findInArchiveDataBase(task);
      await _deleteFromArchive(docID);
    } else {
      docID = await _findInTaskDataBase(task);
      await _deleteFromTasks(docID);
    }
    await _addToBin(task);
  }

  Future<void> archiveTask(Task task) async {
    String docID = await _findInTaskDataBase(task);
    await _deleteFromTasks(docID);
    await _addToArchive(task);
  }

  Future<void> unArchiveTask(Task task) async {
    String docID = await _findInArchiveDataBase(task);
    await _deleteFromArchive(docID);
    await addTask(task);
  }

  Future<void> deleteTaskForever(Task task) async {
    String docID = await _findInTaskBinDataBase(task);
    await _deleteFromBin(docID);
  }

  Future<void> recoverTask(Task task) async {
    String docID = await _findInTaskBinDataBase(task);
    await _deleteFromBin(docID);
    await addTask(task);
  }

  Future<void> fetchAllTasks(BuildContext context) async {
    _fetchMainTasks(context);
    _fetchArchivedTasks(context);
    _fetchDeletedTasks(context);
  }

  Future<void> _toggleTaskStatusArchived(Task task, bool status) async {
    String docID = await _findInArchiveDataBase(task);
    var theTask = await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection(kArchivedTasks)
        .doc(docID)
        .get();
    theTask.reference.update(
      {
        'taskStatus': status,
      },
    );
  }

  Future<void> _toggleTaskStatusMain(Task task, bool status) async {
    String docID = await _findInTaskDataBase(task);
    var document = await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection(kTask)
        .doc(docID)
        .get();
    document.reference.update(
      {
        'taskStatus': status,
      },
    );
  }

  Future<void> toggleStatusTasks(
      Task task, bool isArchived, bool status) async {
    if (isArchived) {
      await _toggleTaskStatusArchived(task, status);
    } else {
      await _toggleTaskStatusMain(task, status);
    }
  }

  /// *****************************************************Event related actions *************************/
  void addEvent(Event event) async {
    await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection('events')
        .add(
      {
        'eventTitle': event.title,
        'eventStartDate': event.dateStart,
        'eventEndDate': event.dateEnd,
        'eventStatus': event.eventStatus(),
        'eventID': event.id(),
        'eventID2': event.id2(),
      },
    );
  }

  Future<String> _findEvent(String title) async {
    var events = await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection('events')
        .get();
    var docID;
    for (var doc in events.docs) {
      if (doc.data()['eventTitle'] == title) {
        docID = doc.id;
        break;
      }
    }
    return docID;
  }

  void toggleStatusEvents(String title, bool status) async {
    String docID = await _findEvent(title);
    var document = await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection('events')
        .doc(docID)
        .get();
    document.reference.update(
      {
        'eventStatus': status,
      },
    );
  }

  Future<List> fetchEvents() async {
    var events = await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection('events')
        .get();
    List<Event> eventList = [];
    for (var doc in events.docs) {
      eventList.add(
        Event(
            doc.get('eventTitle'),
            doc.get('eventStartDate').toDate(),
            doc.get('eventEndDate').toDate(),
            doc.get('eventID'),
            doc.get('eventID2')),
      );
    }

    return eventList;
  }

  void deleteEvent(String title) async {
    String docID = await _findEvent(title);
    await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection('events')
        .doc(docID)
        .delete();
  }

  /// *************************************************Notes related Events***************************/
  void addNote(Note note) async {
    await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection('notes')
        .add(
      {
        'noteTitle': note.getTitle,
        'noteText': note.getNote,
        'noteDate': note.getDate,
      },
    );
  }

  Future<String> _findNoteInDataBase(String title) async {
    var notes = await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection('notes')
        .get();
    String docID;
    for (var doc in notes.docs) {
      if (doc.data()['noteTitle'] == title) {
        docID = doc.id;
        break;
      }
    }
    return docID;
  }

  void deleteNoteAndTransferToBin(Note note) async {
    String docID = await _findNoteInDataBase(note.getTitle);
    await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection('notes')
        .doc(docID)
        .delete();
    await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection('binNotes')
        .add(
      {
        'noteTitle': note.getTitle,
        'noteText': note.getNote,
        'noteDate': note.getDate,
      },
    );
  }

  void deleteNoteAndTransferToArchieve(Note note) async {
    String docID = await _findNoteInDataBase(note.getTitle);
    await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection('notes')
        .doc(docID)
        .delete();
    await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection('archieveNotes')
        .add(
      {
        'noteTitle': note.getTitle,
        'noteText': note.getNote,
        'noteDate': note.getDate,
      },
    );
  }

  Future<List> fetchNotes() async {
    var notes = await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection('notes')
        .get();
    List<Note> notesList = [];
    for (var doc in notes.docs) {
      notesList.add(
        Note(doc.get('noteText'), doc.get('noteTitle'),
            doc.get('noteDate').toDate()),
      );
    }
    return notesList;
  }
}
