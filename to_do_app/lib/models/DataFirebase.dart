import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Tasks.dart';

class FirebaseController extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _firestoreReference = FirebaseFirestore.instance.collection('users');

  FirebaseAuth getAuthInstance() {
    return _auth;
  }

  void createNewUserDocument() async {
    await _firestoreReference.doc('${_auth.currentUser.email}').set(
      {'id': '${_auth.currentUser.email}'},
    );
  }

  void createNewTaskSpace() async {
    await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection('tasks')
        .doc('Welcome task')
        .set(
      {
        'taskText': 'Welcome task',
        'taskStatus': '${false}',
      },
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
      },
    );
  }

  void syncTaskList(List<Task> myTasks) async {
    int counter = 0;
    for (Task task in myTasks) {
      await _firestoreReference
          .doc('${_auth.currentUser.email}')
          .collection('tasks')
          .doc('task$counter')
          .set({
        'taskText': '${task.getTask()}',
        'taskStatus': '${task.getState()}'
      });
      counter++;
    }
  }

  CollectionReference getStorageInstance() {
    return _firestoreReference;
  }

  Stream getTasks() {
    return _firestoreReference
        .doc(_auth.currentUser.email)
        .collection('tasks')
        .snapshots();
  }
}
