class Task {
  //Attributes
  String _task;
  bool _status;

  //Constructor
  Task() {
    _task = '';
    _status = false;
  }
  Task.fromParam({String task, bool status})
      : _task = task,
        _status = status;

  //Method to toggle the state
  void toggleState() {
    _status = !_status;
  }

  set setTask(String task) {
    _task = task;
  }

  String get task => _task;
  bool get status => _status;
}
