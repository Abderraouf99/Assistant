import 'package:flutter/material.dart';
import 'package:focused_menu/modals.dart';
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
                    Provider.of<FirebaseController>(context, listen: false)
                        .deleteTask(index);
                  },
                ),
              ],
              longPressToDelete: () {},
              theTask: taskList.getTasks()[index],
              checkBoxCallBack: (checkBoxState) {
                taskList.toggleState(index);
                Provider.of<FirebaseController>(context, listen: false)
                    .toggleStatusTask(
                        index, taskList.getTasks()[index].getState());
              },
            );
          },
          itemCount: taskList.getTasks().length,
        );
      },
    );
  }
}
