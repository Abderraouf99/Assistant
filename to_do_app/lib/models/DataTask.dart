import 'package:flutter/material.dart';
import 'Tasks.dart';

class ControllerTask extends ChangeNotifier {
  //Task Controller
  List<Task> _myTasks = [];
  String _task;
  Task _task1;

  Task getTask() {
    return _task1;
  }

  void setTasks(List<Task> taskList) {
    _myTasks = taskList;
  }

  String get task => _task;
  void setTask(String task) {
    _task = task;
    _task1 = Task(task: _task);
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
    _myTasks.add(newTask);
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
