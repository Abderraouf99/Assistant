import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/Widgets/TaskTile.dart';
import 'package:to_do_app/models/DataFirebase.dart';
import 'package:to_do_app/models/DataTask.dart';

class TaskArchieveList extends StatelessWidget {
  final bool _isArchived = true;
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskController>(
      builder: (context, tasks, child) {
        return ListView.builder(
          itemCount: (tasks.archived != null) ? tasks.archived.length : 0,
          itemBuilder: (context, index) {
            return Dismissible(
              direction: DismissDirection.endToStart,
              confirmDismiss: (direction) async {
                await showAlertDialog(
                  context: context,
                  title: 'Task moved to the bin',
                  message: 'When you delete a task it will be moved to the bin',
                  barrierDismissible: false,
                  actions: [
                    AlertDialogAction(label: 'Ok'),
                  ],
                );
                return true;
              },
              background: Container(
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
                theTask: tasks.archived[index],
                checkBoxCallBack: (checkBoxState) async {
                  tasks.toggleState(index, true);
                  await Provider.of<FirebaseController>(context, listen: false)
                      .toggleStatusTasks(
                    tasks.archived[index],
                    _isArchived,
                    tasks.archived[index].getState(),
                  );
                },
              ),
              onDismissed: (direction) {
                //TODO:: Delete from the archive and move it the bin array
              },
            );
          },
        );
      },
    );
  }
}

/**
 * TaskTile(
              theTask: tasks.archived[index],
              checkBoxCallBack: (checkBoxState) async {
                tasks.toggleState(index, true);
                await Provider.of<FirebaseController>(context, listen: false)
                    .toggleStatusArchivedTask(
                  tasks.archived[index],
                  tasks.archived[index].getState(),
                );
              },
            );
          },
 */
