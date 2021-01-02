class Task {
  //Attributes
  final String _task;
  bool _state;
  final int _index;

  //Constructor
  Task({String task, bool status, int index})
      : _task = task,
        _state = status,
        _index = index;

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

  int getIndex() {
    return _index;
  }
}
