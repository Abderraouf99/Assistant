import 'package:flutter_test/flutter_test.dart';
import 'package:to_do_app/models/Tasks.dart';

void main() {
  group('Task', () {
    test('state should be toggled', () {
      final task = Task(task: 'testTask', status: false);
      task.toggleState();
      expect(task.getState(), true);
      task.toggleState();
      expect(task.getState(), false);
    });
    test('task title should change', () {
      Task newTask = Task(task: 'Hello', status: false);
      newTask.setTask = 'hello changed';
      expect(newTask.getTask(), 'hello changed');
    });
  });
}
