import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/Widgets/DeleteDismissWidget.dart';
import 'package:to_do_app/Widgets/NoteTile.dart';
import 'package:to_do_app/models/DataFirebase.dart';
import 'package:to_do_app/models/DataNotes.dart';

import '../unArchiveDismissWidget.dart';

class NoteArchiveList extends StatelessWidget {
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
    return Consumer<NotesController>(
      builder: (context, note, child) {
        return ListView.builder(
          itemBuilder: (context, index) {
            return Dismissible(
              key: UniqueKey(),
              confirmDismiss: (direction) async {
                bool decision;
                if (direction == DismissDirection.endToStart) {
                  decision = await _showAlertDialog(context,
                      title: 'Delete note',
                      message: 'This note will be moved to the bin tab');
                } else {
                  decision = await _showAlertDialog(context,
                      title: 'Unarchive note',
                      message:
                          'This note will be moved back to the main tasks tab');
                }
                return decision;
              },
              background: UnArchiveDismissWidget(),
              secondaryBackground: DeleteDismissWidget(),
              onDismissed: (direction) async {
                if (direction == DismissDirection.endToStart) {
                  await Provider.of<FirebaseController>(context, listen: false)
                      .moveNoteToBin(note.archive[index], _isArchived);
                  note.moveToBin(index, _isArchived);
                } else {
                  Provider.of<FirebaseController>(context, listen: false)
                      .unArchiveNote(note.archive[index]);
                  note.unArchive(index);
                }
              },
              child: NoteTile(
                note: note.archive[index],
              ),
            );
          },
          itemCount: (note.archive != null) ? note.archive.length : 0,
        );
      },
    );
  }
}
