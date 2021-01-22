import 'package:flutter/material.dart';
import 'package:to_do_app/Widgets/DeleteDismissWidget.dart';
import 'package:to_do_app/Widgets/NoteTile.dart';
import 'package:to_do_app/Widgets/RecoverDismissWidget.dart';
import 'package:to_do_app/models/DataNotes.dart';
import 'package:provider/provider.dart';

class NoteBinList extends StatelessWidget {
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
    return Consumer<NotesController>(
      builder: (context, notesController, child) {
        return ListView.builder(
          itemBuilder: (context, index) {
            return Dismissible(
              confirmDismiss: (direction) async {
                bool decision = false;
                if (direction == DismissDirection.endToStart) {
                  decision = await _showAlertDialog(
                    context,
                    title: 'Purge note',
                    message:
                        'This note will be deleted forever and the assistant won\'t be able to retrieve it',
                  );
                } else {
                  decision = await _showAlertDialog(
                    context,
                    title: 'Recover note',
                    message: 'This task will placed back in the main note tab',
                  );
                }
                return decision;
              },
              onDismissed: (direction) async {
                if (direction == DismissDirection.endToStart) {
                  await notesController.purge(index);
                } else {
                  await notesController.recover(index);
                }
              },
              background: RecoverDismissWidget(),
              secondaryBackground: DeleteDismissWidget(),
              key: UniqueKey(),
              child: NoteTile(
                note: notesController.deleted[index],
              ),
            );
          },
          itemCount: (notesController.deleted == null) ? 0 : notesController.deleted.length,
        );
      },
    );
  }
}
