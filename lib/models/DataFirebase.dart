import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/models/DataEvents.dart';
import 'package:to_do_app/models/DataNotes.dart';
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

  Future<void> _deleteTaskFromArchive(String docID) async {
    await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection(kArchivedTasks)
        .doc(docID)
        .delete();
  }

  Future<void> _deleteTaskFromBin(String docID) async {
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

  Future<void> _addToTaskBin(Task task) async {
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

  Future<void> _addToArchiveTask(Task task) async {
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

  Future<void> moveTaskTobin(Task task, bool isArchived) async {
    String docID = '';
    if (isArchived) {
      docID = await _findInArchiveDataBase(task);
      await _deleteTaskFromArchive(docID);
    } else {
      docID = await _findInTaskDataBase(task);
      await _deleteFromTasks(docID);
    }
    await _addToTaskBin(task);
  }

  Future<void> archiveTask(Task task) async {
    String docID = await _findInTaskDataBase(task);
    await _deleteFromTasks(docID);
    await _addToArchiveTask(task);
  }

  Future<void> unArchiveTask(Task task) async {
    String docID = await _findInArchiveDataBase(task);
    await _deleteTaskFromArchive(docID);
    await addTask(task);
  }

  Future<void> deleteTaskForever(Task task) async {
    String docID = await _findInTaskBinDataBase(task);
    await _deleteTaskFromBin(docID);
  }

  Future<void> recoverTask(Task task) async {
    String docID = await _findInTaskBinDataBase(task);
    await _deleteTaskFromBin(docID);
    await addTask(task);
  }

  Future<void> fetchData(BuildContext context) async {
    await _fetchMainTasks(context);
    await _fetchArchivedTasks(context);
    await _fetchDeletedTasks(context);
    await _fetchMainNotes(context);
    await _fetchArchivedNotes(context);
    await _fetchDeletedNotes(context);
    await _fetchEvents(context, dataBase: kEvent);
    await _fetchEvents(context, dataBase: kArchivedEvents);
    await _fetchEvents(context, dataBase: kDeletedEvents);
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
  final String kEvent = 'events';
  final String kArchivedEvents = 'archivedEvents';
  final String kDeletedEvents = 'deletedEvents';

  Future<QuerySnapshot> _getEventQuery({String dataBase}) async {
    QuerySnapshot events = await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection(dataBase)
        .get();
    return events;
  }

  Future<String> _findEvent({Event event, String dataBase}) async {
    String docID;
    QuerySnapshot events = await _getEventQuery(dataBase: dataBase);
    for (var doc in events.docs) {
      if (doc.data()['eventTitle'] == event.title) {
        docID = doc.id;
        break;
      }
    }
    return docID;
  }

  Future<void> _deleteEvent({String docID, String dataBase}) async {
    await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection(dataBase)
        .doc(docID)
        .delete();
  }

  Future<void> _addEvent({Event event, String dataBase}) async {
    await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection(dataBase)
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

  Future<void> _toggleEventStatus({Event event, bool isArchived}) async {
    String dataBase = (isArchived) ? kArchivedEvents : kEvent;
    String docID = await _findEvent(event: event, dataBase: dataBase);
    var document = await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection(dataBase)
        .doc(docID)
        .get();
    document.reference.update(
      {
        'eventStatus': event.eventStatus(),
      },
    );
  }

  Future<void> addEvent(Event event) async {
    await _addEvent(event: event, dataBase: kEvent);
  }

  Future<void> moveEventToBin(Event event, bool isArchived) async {
    String docID = '';
    if (!isArchived) {
      docID = await _findEvent(event: event, dataBase: kEvent);
      await _deleteEvent(docID: docID, dataBase: kEvent);
    } else {
      docID = await _findEvent(event: event, dataBase: kArchivedEvents);
      await _deleteEvent(docID: docID, dataBase: kArchivedEvents);
    }
    await _addEvent(event: event, dataBase: kDeletedEvents);
  }

  Future<void> archiveEvent(Event event) async {
    String docID = await _findEvent(event: event, dataBase: kEvent);
    await _deleteEvent(docID: docID, dataBase: kEvent);
    await _addEvent(event: event, dataBase: kArchivedEvents);
  }

  Future<void> unArchiveEvent(Event event) async {
    String docID = await _findEvent(event: event, dataBase: kArchivedEvents);
    await _deleteEvent(docID: docID, dataBase: kArchivedEvents);
    await _addEvent(event: event, dataBase: kEvent);
  }

  Future<void> deleteEventForever(Event event) async {
    String docID = await _findEvent(event: event, dataBase: kDeletedEvents);
    await _deleteEvent(docID: docID, dataBase: kDeletedNotes);
  }

  Future<void> recoverEvent(Event event) async {
    String docID = await _findEvent(event: event, dataBase: kDeletedEvents);
    await _deleteEvent(docID: docID, dataBase: kDeletedEvents);
    await _addEvent(event: event, dataBase: kEvent);
  }

  Future<void> toggleStatusEvents(Event event, bool isArchived) async {
    await _toggleEventStatus(event: event, isArchived: isArchived);
  }

  Future<void> _fetchEvents(BuildContext context, {String dataBase}) async {
    var events = await _getEventQuery(dataBase: dataBase);
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
    if (dataBase == kEvent) {
      Provider.of<EventsController>(context, listen: false).events = eventList;
    } else if (dataBase == kArchivedEvents) {
      Provider.of<EventsController>(context, listen: false).archived =
          eventList;
    } else {
      Provider.of<EventsController>(context, listen: false).deleted = eventList;
    }
  }

  /// *************************************************Notes related Events***************************/
  final String kNote = 'notes';
  final String kArchivedNotes = 'archieveNotes';
  final String kDeletedNotes = 'binNotes';

  Future<void> addNote(Note note) async {
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

  Future<String> _findArchivedNote(Note note) async {
    String docID = '';
    var notes = await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection(kArchivedNotes)
        .get();

    for (var doc in notes.docs) {
      if (doc.data()['noteTitle'] == note.getTitle) {
        docID = doc.id;
        break;
      }
    }
    return docID;
  }

  Future<String> _findMainNote(Note note) async {
    String docID = '';
    var notes = await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection(kNote)
        .get();

    for (var doc in notes.docs) {
      if (doc.data()['noteTitle'] == note.getTitle) {
        docID = doc.id;
        break;
      }
    }
    return docID;
  }

  Future<String> _findDeletedNote(Note note) async {
    String docID = '';
    var notes = await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection(kDeletedNotes)
        .get();

    for (var doc in notes.docs) {
      if (doc.data()['noteTitle'] == note.getTitle) {
        docID = doc.id;
        break;
      }
    }
    return docID;
  }

  Future<void> _deleteNoteFromArchive(String docID) async {
    await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection(kArchivedNotes)
        .doc(docID)
        .delete();
  }

  Future<void> _deleteNoteFromMain(String docID) async {
    await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection(kNote)
        .doc(docID)
        .delete();
  }

  Future<void> _deleteNoteFromBin(String docID) async {
    await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection(kDeletedNotes)
        .doc(docID)
        .delete();
  }

  Future<void> _addToNoteBin(Note note) async {
    await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection(kDeletedNotes)
        .add(
      {
        'noteTitle': note.getTitle,
        'noteText': note.getNote,
        'noteDate': note.getDate,
      },
    );
  }

  Future<void> _addToNoteArchive(Note note) async {
    await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection(kArchivedNotes)
        .add(
      {
        'noteTitle': note.getTitle,
        'noteText': note.getNote,
        'noteDate': note.getDate,
      },
    );
  }

  Future<void> _fetchMainNotes(BuildContext context) async {
    var notes = await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection(kNote)
        .get();
    List<Note> notesList = [];
    for (var doc in notes.docs) {
      notesList.add(
        Note(doc.get('noteText'), doc.get('noteTitle'),
            doc.get('noteDate').toDate()),
      );
    }
    Provider.of<NotesController>(context, listen: false).setNote(notesList);
  }

  Future<void> _fetchArchivedNotes(BuildContext context) async {
    var notes = await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection(kArchivedNotes)
        .get();
    List<Note> notesList = [];
    for (var doc in notes.docs) {
      notesList.add(
        Note(doc.get('noteText'), doc.get('noteTitle'),
            doc.get('noteDate').toDate()),
      );
    }
    Provider.of<NotesController>(context, listen: false)
        .setArchivedNotes(notesList);
  }

  Future<void> _fetchDeletedNotes(BuildContext context) async {
    var notes = await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection(kDeletedNotes)
        .get();
    List<Note> notesList = [];
    for (var doc in notes.docs) {
      notesList.add(
        Note(doc.get('noteText'), doc.get('noteTitle'),
            doc.get('noteDate').toDate()),
      );
    }
    Provider.of<NotesController>(context, listen: false)
        .setDeletedNotes(notesList);
  }

  Future<void> moveNoteToBin(Note note, bool isArchived) async {
    String docID = '';
    if (isArchived) {
      docID = await _findArchivedNote(note);
      await _deleteNoteFromArchive(docID);
    } else {
      docID = await _findMainNote(note);
      await _deleteNoteFromMain(docID);
    }
    await _addToNoteBin(note);
  }

  Future<void> archiveNote(Note note) async {
    String docID = await _findMainNote(note);
    await _deleteNoteFromMain(docID);
    await _addToNoteArchive(note);
  }

  Future<void> unArchiveNote(Note note) async {
    String docID = await _findArchivedNote(note);
    await _deleteNoteFromArchive(docID);
    await addNote(note);
  }

  Future<void> deleteNoteForever(Note note) async {
    String docID = await _findDeletedNote(note);
    await _deleteNoteFromBin(docID);
  }

  Future<void> recoverNote(Note note) async {
    String docID = await _findDeletedNote(note);
    await _deleteNoteFromBin(docID);
    await addNote(note);
  }
}
