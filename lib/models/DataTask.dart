import 'package:flutter/material.dart';
import 'Tasks.dart';

class ControllerTask extends ChangeNotifier {
  //Task Controller
  List<Task> _myTasks = [];

  Task _task1;

  Task getTask() {
    return _task1;
  }

  String get task => _task1.getTask();
  void setTasks(List<Task> taskList) {
    _myTasks = taskList;
  }

  void setTask(String task) {
    _task1 = Task(task: task);
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
