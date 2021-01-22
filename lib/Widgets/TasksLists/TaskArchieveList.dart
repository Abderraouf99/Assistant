import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/Widgets/TaskTile.dart';
import 'package:to_do_app/Widgets/unArchiveDismissWidget.dart';
import 'package:to_do_app/models/DataFirebase.dart';
import 'package:to_do_app/models/DataTask.dart';

import '../DeleteDismissWidget.dart';

class TaskArchiveList extends StatelessWidget {
  final bool _isArchived = true;
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

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskController>(
      builder: (context, tasksController, child) {
        return ListView.builder(
          itemCount: (tasksController.archived != null)
              ? tasksController.archived.length
              : 0,
          itemBuilder: (context, index) {
            return Dismissible(
              confirmDismiss: (direction) async {
                bool decision = false;
                if (direction == DismissDirection.endToStart) {
                  decision = await _showAlertDialog(context,
                      title: 'Delete task',
                      message: 'This task will be moved to the bin tab');
                } else {
                  decision = await _showAlertDialog(context,
                      title: 'Unarchive task',
                      message:
                          'This task will be moved back to the main tasks tab');
                }

                return decision;
              },
              background: UnArchiveDismissWidget(),
              secondaryBackground: DeleteDismissWidget(),
              key: UniqueKey(),
              child: TaskTile(
                theTask: tasksController.archived[index],
                checkBoxCallBack: (checkBoxState) async {
                  await tasksController.toggleState(index, true);
                },
              ),
              onDismissed: (direction) async {
                if (direction == DismissDirection.endToStart) {
                  await tasksController.moveTobin(index, _isArchived);
                } else {
                  await tasksController.unArchiveTask(index);
                }
              },
            );
          },
        );
      },
    );
  }
}
