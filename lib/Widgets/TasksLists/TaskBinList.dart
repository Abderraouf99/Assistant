import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/Widgets/DeleteDismissWidget.dart';
import 'package:to_do_app/Widgets/TaskTile.dart';
import 'package:to_do_app/models/DataFirebase.dart';
import 'package:to_do_app/models/DataTask.dart';

import '../RecoverDismissWidget.dart';

class TaskBinList extends StatelessWidget {
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
          itemCount: (tasksController.deleted == null) ? 0 : tasksController.deleted.length,
          itemBuilder: (context, index) {
            return Dismissible(
              confirmDismiss: (direction) async {
                bool decision = false;
                if (direction == DismissDirection.endToStart) {
                  decision = await _showAlertDialog(
                    context,
                    title: 'Purge task',
                    message:
                        'This task will be deleted forever and the assistant won\'t be able to retrieve it',
                  );
                } else {
                  decision = await _showAlertDialog(
                    context,
                    title: 'Recover task',
                    message: 'This task will placed back in the main task tab',
                  );
                }
                return decision;
              },
              onDismissed: (direction) async {
                if (direction == DismissDirection.endToStart) {
                  await tasksController.purgeTask(index);
                } else {
                  await tasksController.recoverTask(index);
                }
              },
              background: RecoverDismissWidget(),
              secondaryBackground: DeleteDismissWidget(),
              key: UniqueKey(),
              child: TaskTile(
                  theTask: tasksController.deleted[index],
                  checkBoxCallBack: (checkBoxState) {}),
            );
          },
        );
      },
    );
  }
}
