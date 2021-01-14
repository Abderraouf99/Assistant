import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/Widgets/NoteTile.dart';
import 'package:to_do_app/models/DataNotes.dart';

class NoteList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<NotesController>(
      builder: (context, note, child) {
        return ListView.builder(
          // padding: EdgeInsets.all(5),
          itemBuilder: (context, index) {
            return NoteTile(
              note: note.notes[index],
            );
          },
          itemCount: note.notes.length,
        );
      },
    );
  }
}
