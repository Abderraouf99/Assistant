import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Tasks.dart';

class FirebaseController extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _firestoreReference = FirebaseFirestore.instance.collection('users');

  Future<List> fetchData() async {
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

  void toggleStatus(int index, bool status) async {
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
}
