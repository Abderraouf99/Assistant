import 'package:flutter/material.dart';
import 'package:to_do_app/models/DataFirebase.dart';
import 'TaskTile.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/models/DataTask.dart';

class TasksList extends StatelessWidget {
  Widget build(BuildContext context) {
    return Consumer<ControllerTask>(
      builder: (context, taskList, child) {
        return ListView.builder(
          itemBuilder: (context, index) {
            return Dismissible(
              background: Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.red,
                ),
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              key: UniqueKey(),
              child: TaskTile(
                theTask: taskList.getTasks()[index],
                checkBoxCallBack: (checkBoxState) {
                  taskList.toggleState(index);
                  Provider.of<FirebaseController>(context, listen: false)
                      .toggleStatusTask(
                    index,
                    taskList.getTasks()[index].getState(),
                  );
                },
              ),
              onDismissed: (direction) {
                taskList.deleteTask(index);
                Provider.of<FirebaseController>(context, listen: false)
                    .deleteTask(index);
              },
            );
          },
          itemCount: taskList.getTasks().length,
        );
      },
    );
  }
}
