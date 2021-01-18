import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/Widgets/NoteTile.dart';
import 'package:to_do_app/models/DataFirebase.dart';
import 'package:to_do_app/models/DataNotes.dart';

class NoteArchiveList extends StatelessWidget {
  final bool _isArchived = true;
  @override
  Widget build(BuildContext context) {
    return Consumer<NotesController>(
      builder: (context, note, child) {
        return ListView.builder(
          itemBuilder: (context, index) {
            return NoteTile(
              note: note.archive[index],
              isArchived: _isArchived,
              deleteFunction: () {
                //TODO: add a delete function
                Provider.of<FirebaseController>(context, listen: false)
                    .moveNoteToBin(note.archive[index], _isArchived);
                note.removeAndAddTobin(index, _isArchived);
              },
              archiveFunction: () {
                Provider.of<FirebaseController>(context, listen: false)
                    .unArchiveNote(note.archive[index]);
                note.unArchive(index);
              },
            );
          },
          itemCount: (note.archive != null) ? note.archive.length : 0,
        );
      },
    );
  }
}
