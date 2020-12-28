class Task {
  //Attributes
  final String _task;
  bool _state = false;

  //Constructor
  Task({String task}) : _task = task;

  //Method to toggle the state
  void toggleState() {
    _state = !_state;
  }

  String getTask() {
    return this._task;
  }

  bool getState() {
    return this._state;
  }
}
