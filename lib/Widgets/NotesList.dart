import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/Widgets/NoteTile.dart';
import 'package:to_do_app/models/DataFirebase.dart';
import 'package:to_do_app/models/DataNotes.dart';

class NoteList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<NotesController>(
      builder: (context, note, child) {
        return ListView.builder(
          itemBuilder: (context, index) {
            return NoteTile(
              note: note.notes[index],
              deleteFunction: () {
                Provider.of<FirebaseController>(context, listen: false)
                    .deleteNoteAndTransferToBin(
                  note.notes[index],
                );
                note.removeAndAddTobin(index);
              },
              archiveFunction: () {
                Provider.of<FirebaseController>(context, listen: false)
                    .deleteNoteAndTransferToArchieve(
                  note.notes[index],
                );

                note.removeAndAddToArchive(index);
              },
            );
          },
          itemCount: (note.notes != null) ? note.notes.length : 0,
        );
      },
    );
  }
}
