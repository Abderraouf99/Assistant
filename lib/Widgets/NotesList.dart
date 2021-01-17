import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/Widgets/NoteTile.dart';
import 'package:to_do_app/models/DataFirebase.dart';
import 'package:to_do_app/models/DataNotes.dart';

class NoteList extends StatelessWidget {
  final bool _isArchived = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<NotesController>(
      builder: (context, note, child) {
        return ListView.builder(
          itemBuilder: (context, index) {
            return NoteTile(
              isArchived: _isArchived,
              note: note.notes[index],
              deleteFunction: () {
                Provider.of<FirebaseController>(context, listen: false)
                    .moveNoteToBin(note.notes[index], _isArchived);
                note.removeAndAddTobin(index, _isArchived);
              },
              archiveFunction: () {
                Provider.of<FirebaseController>(context, listen: false)
                    .archiveNote(note.notes[index]);

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
