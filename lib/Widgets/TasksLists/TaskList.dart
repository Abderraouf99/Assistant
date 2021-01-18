import 'package:flutter/material.dart';
import 'package:to_do_app/Widgets/DeleteDismissWidget.dart';
import 'package:to_do_app/models/DataFirebase.dart';
import '../TaskTile.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/models/DataTask.dart';

class TasksList extends StatelessWidget {
  final bool _isArchived = false;
  Future<bool> _showAlertDialog(BuildContext context,
      {String title, String message}) async {
    bool choice = false;
    Widget cancelButton = TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: Text('Cancel'),
    );
    Widget okButton = TextButton(
      onPressed: () {
        choice = true;
        Navigator.pop(context);
      },
      child: Text('Ok'),
    );

    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [cancelButton, okButton],
    );

    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return alert;
        });
    return choice;
  }

  Widget build(BuildContext context) {
    return Consumer<TaskController>(
      builder: (context, taskList, child) {
        return ListView.builder(
          itemBuilder: (context, index) {
            return Dismissible(
              confirmDismiss: (direction) async {
                bool decision = false;
                if (direction == DismissDirection.endToStart) {
                  decision = await _showAlertDialog(
                    context,
                    title: 'Delete task',
                    message: 'Deleted tasks will be moved to the bin tab',
                  );
                } else {
                  decision = await _showAlertDialog(
                    context,
                    title: 'Archive task',
                    message: 'Archived tasks will be moved to the archive tab ',
                  );
                }
                return decision;
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
              secondaryBackground: DeleteDismissWidget(),
              key: UniqueKey(),
              child: TaskTile(
                theTask: taskList.getTasks()[index],
                checkBoxCallBack: (checkBoxState) async {
                  taskList.toggleState(index, false);
                  await Provider.of<FirebaseController>(context, listen: false)
                      .toggleStatusTasks(
                    taskList.getTasks()[index],
                    _isArchived,
                  );
                },
              ),
              onDismissed: (direction) async {
                if (direction == DismissDirection.endToStart) {
                  await Provider.of<FirebaseController>(context, listen: false)
                      .moveTaskTobin(taskList.getTasks()[index], _isArchived);
                  taskList.moveTobin(index, _isArchived);
                } else {
                  await Provider.of<FirebaseController>(context, listen: false)
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
