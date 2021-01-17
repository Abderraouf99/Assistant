import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/Widgets/NoteTile.dart';
import 'package:to_do_app/models/DataFirebase.dart';
import 'package:to_do_app/models/DataNotes.dart';

class NoteArchieveList extends StatelessWidget {
  final bool _isArchived = true;
  @override
  Widget build(BuildContext context) {
    return Consumer<NotesController>(
      builder: (context, note, child) {
        return ListView.builder(
          itemBuilder: (context, index) {
            return NoteTile(
              note: note.archieve[index],
              isArchived: _isArchived,
              deleteFunction: () {
                //TODO: add a delete function
                Provider.of<FirebaseController>(context, listen: false)
                    .moveNoteToBin(note.archieve[index], _isArchived);
                note.removeAndAddTobin(index, _isArchived);
              },
              archiveFunction: () {
                Provider.of<FirebaseController>(context, listen: false)
                    .unArchiveNote(note.archieve[index]);
                note.unArchive(index);
              },
            );
          },
          itemCount: (note.archieve != null) ? note.archieve.length : 0,
        );
      },
    );
  }
}
