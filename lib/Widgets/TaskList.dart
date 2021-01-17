import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/models/DataFirebase.dart';
import 'TaskTile.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/models/DataTask.dart';

class TasksList extends StatelessWidget {
  final bool _isNotArchived = false;
  Widget build(BuildContext context) {
    return Consumer<TaskController>(
      builder: (context, taskList, child) {
        return ListView.builder(
          itemBuilder: (context, index) {
            return Dismissible(
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.endToStart) {
                  await showAlertDialog(
                    context: context,
                    title: 'Task moved to the bin',
                    message:
                        'When you delete a task it will be moved to the bin',
                    barrierDismissible: false,
                    actions: [
                      AlertDialogAction(label: 'Ok'),
                    ],
                  );
                } else {
                  await showAlertDialog(
                    context: context,
                    title: 'Task moved to the archive',
                    message:
                        'When you archive a task it will be moved to the archive tab',
                    barrierDismissible: false,
                    actions: [
                      AlertDialogAction(label: 'Ok'),
                    ],
                  );
                }
                return true;
              },
              background: Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.orange,
                ),
                child: Icon(
                  Icons.archive,
                  color: Colors.white,
                ),
              ),
              secondaryBackground: Container(
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
                checkBoxCallBack: (checkBoxState) async {
                  taskList.toggleState(index, false);
                  await Provider.of<FirebaseController>(context, listen: false)
                      .toggleStatusTasks(
                    taskList.getTasks()[index],
                    _isNotArchived,
                    taskList.getTasks()[index].getState(),
                  );
                },
              ),
              onDismissed: (direction) {
                if (direction == DismissDirection.endToStart) {
                  Provider.of<FirebaseController>(context, listen: false)
                      .moveTaskTobin(taskList.getTasks()[index], _isNotArchived);
                  taskList.deleteTask(index);
                } else {
                  Provider.of<FirebaseController>(context, listen: false)
                      .archiveTask(taskList.getTasks()[index]);
                  taskList.archiveTask(index);
                }
              },
            );
          },
          itemCount: taskList.getTasks().length,
        );
      },
    );
  }
}
