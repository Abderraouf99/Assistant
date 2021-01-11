import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Tasks.dart';
import 'Event.dart';

class FirebaseController extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _firestoreReference = FirebaseFirestore.instance.collection('users');
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void toggleIsLoading(){
    _isLoading = ! _isLoading;
    notifyListeners();
  }
  Future<List> fetchTasks() async {
    var task = await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection('tasks')
        .get();
    List<Task> taskList = [];
    for (var doc in task.docs) {
      taskList.add(
        Task(
          task: doc.get('taskText'),
          status: doc.get('taskStatus'),
          index: doc.get('taskIndex'),
        ),
      );
    }
    return taskList;
  }

  FirebaseAuth getAuthInstance() {
    return _auth;
  }

  void createNewUserDocument() async {
    await _firestoreReference.doc('${_auth.currentUser.email}').set(
      {'id': '${_auth.currentUser.email}'},
    );
  }

  void addTask(Task task) async {
    await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection('tasks')
        .add(
      {
        'taskText': task.getTask(),
        'taskStatus': task.getState(),
        'taskIndex': task.getIndex(),
      },
    );
  }

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
        'eventID2':event.id2(),
      },
    );
  }

  Future<String> _findInDataBase(int index) async {
    var tasks = await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection('tasks')
        .get();
    var docID;
    for (var doc in tasks.docs) {
      if (doc.data()['taskIndex'] == index) {
        docID = doc.id;
        break;
      }
    }
    return docID;
  }

  Future<void> _updateIndex() async {
    var tasksUpdated = await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection('tasks')
        .get();
    int counter = 0;
    for (var doc in tasksUpdated.docs) {
      doc.reference.update(
        {
          'taskIndex': counter,
        },
      );
      counter++;
    }
  }

  void deleteTask(int index) async {
    String docID = await _findInDataBase(index);
    await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection('tasks')
        .doc(docID)
        .delete();
    await _updateIndex();
  }

  void toggleStatusTask(int index, bool status) async {
    String docID = await _findInDataBase(index);
    var document = await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection('tasks')
        .doc(docID)
        .get();
    document.reference.update(
      {
        'taskStatus': status,
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
          doc.get('eventID2')
        ),
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
}
