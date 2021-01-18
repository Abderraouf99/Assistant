class Task {
  //Attributes
  String _task;
  bool _state;

  //Constructor
  Task({String task, bool status})
      : _task = task,
        _state = status;

  //Method to toggle the state
  void toggleState() {
    _state = !_state;
  }

  set task(String task) {
    _task = task;
  }

  String getTask() {
    return this._task;
  }

  bool getState() {
    return this._state;
  }

}
