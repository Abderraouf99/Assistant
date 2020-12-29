import 'package:flutter/material.dart';
import 'Tasks.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Data extends ChangeNotifier {
  //Attributes
  List<Task> _myTasks = [];
  final _auth = FirebaseAuth.instance;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _timeOfDay = TimeOfDay.now();

  //Methods
  TimeOfDay getSelectedTime() {
    return _timeOfDay;
  }

  void setTime(TimeOfDay selected) {
    _timeOfDay = selected;
    notifyListeners();
  }

  void setDate(DateTime selected) {
    _selectedDate = selected;
    notifyListeners();
  }

  DateTime getSelectedDate() {
    return _selectedDate;
  }

  FirebaseAuth getAuthInstance() {
    return _auth;
  }

  int getNumberOfTasks() {
    return _myTasks.length;
  }

  int getNumberOfTaskCompleted() {
    int completedTask = 0;
    for (Task task in _myTasks) {
      if (task.getState() == true) {
        completedTask++;
      }
    }
    return completedTask;
  }

  List<Task> getTasks() {
    return _myTasks;
  }

  void addTasks(Task newTask) {
    _myTasks.insert(0, newTask);
    notifyListeners();
  }

  void deleteTask(int index) {
    _myTasks.removeAt(index);
    notifyListeners();
  }

  void toggleState(int index) {
    _myTasks[index].toggleState();
    notifyListeners();
  }
}
