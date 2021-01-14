import 'package:flutter/material.dart';
import 'package:to_do_app/constants.dart';
import 'package:to_do_app/models/Note.dart';
import 'package:intl/intl.dart';

class NoteTile extends StatelessWidget {
  final Note note;
  NoteTile({@required this.note});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //ADD the show more details part
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: (Theme.of(context).brightness == Brightness.dark)
              ? Color(0xffffbd69)
              : Color(0xff30475e),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${note.getTitle}',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xffEEEEEE),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              '${note.getNote}',
              style: TextStyle(
                fontSize: 20,
                color: Color(0xffEEEEEE),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              '${DateFormat('EEE,d/M,y').format(note.getDate)} at ${DateFormat('jm').format(note.getDate)}',
              style: TextStyle(
                color: Color(0xffEEEEEE),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
