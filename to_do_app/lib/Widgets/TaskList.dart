import 'package:flutter/material.dart';
import 'package:focused_menu/modals.dart';
import 'TaskTile.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/models/Data.dart';

class TasksList extends StatelessWidget {
  Widget build(BuildContext context) {
    return Consumer<Data>(builder: (context, taskList, child) {
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
            theTask: taskList.getTasks()[index],
            checkBoxCallBack: (checkBoxState) {
              taskList.toggleState(index);
            },
          );
        },
        itemCount: taskList.getNumberOfTasks(),
      );
    });
  }
}
