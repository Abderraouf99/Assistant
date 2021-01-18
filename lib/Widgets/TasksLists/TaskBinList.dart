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
      builder: (context, tasks, child) {
        return ListView.builder(
          itemCount: (tasks.deleted == null) ? 0 : tasks.deleted.length,
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
                  await Provider.of<FirebaseController>(context, listen: false)
                      .purgeTask(tasks.deleted[index]);
                  tasks.purgeTask(index);
                } else {
                  await Provider.of<FirebaseController>(context, listen: false)
                      .recoverTask(tasks.deleted[index]);
                  tasks.recoverTask(index);
                }
              },
              background: RecoverDismissWidget(),
              secondaryBackground: DeleteDismissWidget(),
              key: UniqueKey(),
              child: TaskTile(
                  theTask: tasks.deleted[index],
                  checkBoxCallBack: (checkBoxState) {}),
            );
          },
        );
      },
    );
  }
}


