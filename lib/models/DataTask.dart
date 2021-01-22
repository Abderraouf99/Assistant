import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Tasks.dart';

const String kArchivedTasks = 'archiveTask';
const String kTask = 'tasks';
const String kDeletedTasks = "binTasks";

class TaskController extends ChangeNotifier {
  //Task Controller
  List<Task> _tasks = [];
  List<Task> _archived = [];
  List<Task> _deleted = [];
  final _auth = FirebaseAuth.instance;
  final _firestoreReference = FirebaseFirestore.instance.collection('users');

  List get tasks => _tasks;
  List get archived => _archived;
  List get deleted => _deleted;

  set setTasks(List<Task> tasks) {
    _tasks = tasks;
  }

  set setArchived(List<Task> tasks) {
    _archived = tasks;
  }

  set setDeleted(List<Task> deleted) {
    _deleted = deleted;
  }

  int getNumberOfTaskCompleted() {
    int completedTask = 0;
    for (Task task in _tasks) {
      if (task.status == true) {
        completedTask++;
      }
    }
    return completedTask;
  }

  Future<void> addTasks(Task newTask) async {
    _tasks.add(newTask);
    await _addTaskFirebase(task: newTask, dataBase: kTask);
    notifyListeners();
  }

  Future<void> moveTobin(int index, bool isArchived) async {
    Task task = (isArchived) ? _archived[index] : _tasks[index];
    _deleted.add(task);
    await _moveTaskTobinFirebase(task, isArchived);
    (isArchived) ? _archived.removeAt(index) : _tasks.removeAt(index);
    notifyListeners();
  }

  Future<void> unArchiveTask(int index) async {
    Task task = _archived[index];
    _tasks.add(task);
    await _unArchiveTaskFirebase(task);
    _archived.removeAt(index);
    notifyListeners();
  }

  Future<void> archiveTask(int index) async {
    Task task = _tasks[index];
    _archived.add(task);
    await _archiveTaskFirebase(task);
    _tasks.removeAt(index);
    notifyListeners();
  }

  Future<void> purgeTask(int index) async {
    Task task = _deleted[index];
    await _purgeTaskFirebase(task);
    _deleted.removeAt(index);
    notifyListeners();
  }

  Future<void> recoverTask(int index) async {
    Task task = _deleted[index];
    await _recoverTaskFirebase(task);
    _tasks.add(task);
    _deleted.removeAt(index);
    notifyListeners();
  }

  Future<void> toggleState(int index, bool isArchived) async {
    Task task = (isArchived) ? _archived[index] : _tasks[index];
    await _toggleTaskStatusFirebase(task: task, isArchived: isArchived);
    (isArchived) ? _archived[index].toggleState() : _tasks[index].toggleState();
    notifyListeners();
  }

  Future<void> _addTaskFirebase({Task task, String dataBase}) async {
    await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection(dataBase)
        .add(
      {
        'taskText': task.task,
        'taskStatus': task.status,
      },
    );
  }

  Future<QuerySnapshot> _getTaskQuery({String dataBase}) async {
    QuerySnapshot tasks = await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection(dataBase)
        .get();
    return tasks;
  }

  Future<String> _findTask({Task task, String dataBase}) async {
    String docID;
    QuerySnapshot tasks = await _getTaskQuery(dataBase: dataBase);
    for (var document in tasks.docs) {
      if (document.data()['taskText'] == task.task) {
        docID = document.id;
        break;
      }
    }
    return docID;
  }

  Future<void> _deleteTask({String docID, String dataBase}) async {
    await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection(dataBase)
        .doc(docID)
        .delete();
  }

  Future<void> _fetchTasks({String dataBase}) async {
    var task = await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection(dataBase)
        .get();
    List<Task> taskList = [];
    for (var doc in task.docs) {
      taskList.add(
        Task.fromParam(
          task: doc.get('taskText'),
          status: doc.get('taskStatus'),
        ),
      );
    }
    if (dataBase == kTask) {
      _tasks = taskList;
    } else if (dataBase == kArchivedTasks) {
      _archived = archived;
    } else {
      _deleted = taskList;
    }
  }

  Future<void> _moveTaskTobinFirebase(Task task, bool isArchived) async {
    String docID = '';
    if (isArchived) {
      docID = await _findTask(dataBase: kArchivedTasks, task: task);
      await _deleteTask(dataBase: kArchivedTasks, docID: docID);
    } else {
      docID = await _findTask(dataBase: kTask, task: task);
      await _deleteTask(docID: docID, dataBase: kTask);
    }
    await _addTaskFirebase(task: task, dataBase: kDeletedTasks);
  }

  Future<void> _archiveTaskFirebase(Task task) async {
    String docID = await _findTask(dataBase: kTask, task: task);
    await _deleteTask(dataBase: kTask, docID: docID);
    await _addTaskFirebase(task: task, dataBase: kArchivedTasks);
  }

  Future<void> _unArchiveTaskFirebase(Task task) async {
    String docID = await _findTask(
      dataBase: kArchivedTasks,
      task: task,
    );
    await _deleteTask(
      docID: docID,
      dataBase: kArchivedTasks,
    );
    await _addTaskFirebase(task: task, dataBase: kTask);
  }

  Future<void> _purgeTaskFirebase(Task task) async {
    String docID = await _findTask(
      dataBase: kDeletedTasks,
      task: task,
    );
    await _deleteTask(
      dataBase: kDeletedTasks,
      docID: docID,
    );
  }

  Future<void> _recoverTaskFirebase(Task task) async {
    String docID = await _findTask(dataBase: kDeletedTasks, task: task);
    await _deleteTask(
      dataBase: kDeletedTasks,
      docID: docID,
    );
    await _addTaskFirebase(task: task, dataBase: kTask);
  }

  Future<void> fetchData() async {
    await _fetchTasks(dataBase: kTask);
    await _fetchTasks(dataBase: kArchivedTasks);
    await _fetchTasks(dataBase: kDeletedTasks);
  }

  Future<void> _toggleTaskStatusFirebase({Task task, bool isArchived}) async {
    String dataBase = (isArchived) ? kArchivedTasks : kTask;
    String docID = await _findTask(
      dataBase: dataBase,
      task: task,
    );
    var document = await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection(dataBase)
        .doc(docID)
        .get();
    document.reference.update(
      {
        'taskStatus': task.status,
      },
    );
  }
}
