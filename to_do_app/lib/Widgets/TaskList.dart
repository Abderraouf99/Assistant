import 'package:flutter/material.dart';
import 'package:focused_menu/modals.dart';
import 'TaskTile.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/models/DataTask.dart';
import 'package:to_do_app/models/DataFirebase.dart';
import 'package:to_do_app/models/Tasks.dart';

class TasksList extends StatelessWidget {
  Widget build(BuildContext context) {
    return Consumer<ControllerTask>(
      builder: (context, taskList, child) {
        return StreamBuilder(
            stream: Provider.of<FirebaseController>(context).getTasks(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              List<Task> myTasks = [];
              if (snapshot.hasData) {
                final tasks = snapshot.data.docs;
                for (var task in tasks) {
                  final taskText = task.data()['taskText'];
                  final taskStatus = task.data()['taskStatus'];
                  final taskData = Task(task: taskText, status: taskStatus);
                  myTasks.add(taskData);
                }
              }
              return ListView.builder(
                itemBuilder: (context, index) {
                  return TaskTile(
                    menu: [
                      FocusedMenuItem(
                        title: Row(
                          children: [
                            Icon(Icons.delete),
                            Text('Delete'),
                          ],
                        ),
                        onPressed: () {
                          taskList.deleteTask(index);
                        },
                      ),
                    ],
                    longPressToDelete: () {},
                    theTask: myTasks[index],
                    checkBoxCallBack: (checkBoxState) {
                      myTasks[index].toggleState();
                    },
                  );
                },
                itemCount: myTasks.length,
              );
            });
      },
    );
  }
}
