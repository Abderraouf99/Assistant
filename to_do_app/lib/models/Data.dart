import 'package:flutter/material.dart';
import 'Tasks.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:to_do_app/models/Event.dart';

class Controller extends ChangeNotifier {
  //Attributes
  List<Task> _myTasks = [];
  final _auth = FirebaseAuth.instance;
  DateTime _selectedStartingDate = DateTime.now();
  TimeOfDay _timeOfDay = TimeOfDay.now();

  DateTime _selectedEndDate = DateTime.now();
  TimeOfDay _timeOfDayEnd = TimeOfDay.now();

  bool toBeReminded = false;

  List<Event> _myEvents = [];
  //Methods
  List<Event> get events => _myEvents;

  void addEvent(Event newEvent) {
    _myEvents.add(newEvent);
    notifyListeners();
  }

  void removeEvent(int index) {
    _myEvents.removeAt(index);
    notifyListeners();
  }

  void setEndDate(DateTime selected) {
    _selectedEndDate = selected;
    notifyListeners();
  }

  void setTimeOfEnd(TimeOfDay selected) {
    _timeOfDayEnd = selected;
    notifyListeners();
  }

  TimeOfDay getTimeofDayEnd() {
    return _timeOfDayEnd;
  }

  DateTime getSelectedEndDate() {
    return _selectedEndDate;
  }

  TimeOfDay getSelectedTime() {
    return _timeOfDay;
  }

  void setTime(TimeOfDay selected) {
    _timeOfDay = selected;
    notifyListeners();
  }

  void setStartDate(DateTime selected) {
    _selectedStartingDate = selected;
    notifyListeners();
  }

  DateTime getStartDate() {
    return _selectedStartingDate;
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
