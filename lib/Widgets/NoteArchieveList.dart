import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/Widgets/NoteTile.dart';
import 'package:to_do_app/models/DataNotes.dart';

class NoteArchieveList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<NotesController>(
      builder: (context, note, child) {
        return ListView.builder(
          itemBuilder: (context, index) {
            return NoteTile(
              note: note.archieve[index],
              deleteFunction: () {
                //TODO: add a delete function
              },
            );
          },
          itemCount: (note.archieve != null) ? note.archieve.length : 0,
        );
      },
    );
  }
}
