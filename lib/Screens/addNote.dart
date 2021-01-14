import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/constants.dart';
import 'package:to_do_app/models/DataNotes.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/models/Note.dart';

class AddNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<NotesController>(
      builder: (context, note, child) {
        return Container(
          color: Color(0xff757575),
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: kRoundedContainerDecorator.copyWith(
              color: Theme.of(context).primaryColorDark,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Add a note',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 30,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    FlatButton(
                      shape: CircleBorder(),
                      onPressed: () {
                        Note newNote = new Note(
                          note.note,
                          note.title,
                          note.date,
                        );
                        note.addNote(newNote);
                      },
                      child: CircleAvatar(
                        child: Icon(
                          Icons.add,
                          color: Color(0xffEEEEEE),
                        ),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  autofocus: true,
                  onChanged: (value) {
                    note.title = value;
                  },
                  decoration: (Theme.of(context).brightness == Brightness.dark)
                      ? kTextFieldDecoration.copyWith(
                          hintText: 'Title',
                          hintStyle: TextStyle(
                            color: Color(0xffEEEEEE),
                          ),
                        )
                      : kTextFieldDecoration.copyWith(
                          hintText: 'Title',
                          hintStyle: TextStyle(
                            color: Color(0xff222831),
                          ),
                        ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  maxLines: null,
                  autofocus: true,
                  onChanged: (value) {
                    note.note = value;
                  },
                  decoration: (Theme.of(context).brightness == Brightness.dark)
                      ? kTextFieldDecoration.copyWith(
                          hintText: 'Note',
                          hintStyle: TextStyle(
                            color: Color(0xffEEEEEE),
                          ),
                        )
                      : kTextFieldDecoration.copyWith(
                          hintText: 'Note',
                          hintStyle: TextStyle(
                            color: Color(0xff222831),
                          ),
                        ),
                ),
                SizedBox(
                  height: 10,
                ),
                FlatButton(
                  padding: EdgeInsets.all(0),
                  onPressed: () async {
                    DateTime date = await showDatePicker(
                      context: context,
                      firstDate: DateTime(DateTime.now().year),
                      lastDate: DateTime(DateTime.now().year + 5),
                      initialDate: DateTime.now(),
                      initialDatePickerMode: DatePickerMode.day,
                    );
                    if (date != null) {
                      TimeOfDay time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      note.date = new DateTime(
                        date.year,
                        date.month,
                        date.day,
                        time.hour,
                        time.minute,
                      );
                    }
                  },
                  child: ListTile(
                    leading: Text('Time'),
                    trailing: Text(
                        '${DateFormat('EEE,d/M,y').format(note.date)} at ${DateFormat('jm').format(note.date)}'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
