import 'package:flutter/material.dart';
import 'package:to_do_app/models/Note.dart';
import 'package:intl/intl.dart';

class NoteTile extends StatelessWidget {
  final Note note;

  NoteTile({
    @required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: (Theme.of(context).brightness == Brightness.dark)
            ? Color(0xff51c2d5)
            : Color(0xff30475e),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              note.title,
              style: TextStyle(
                fontSize: 22,
                color: Color(0xffEEEEEE),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            '${note.note}',
            style: TextStyle(
              fontSize: 20,
              color: Color(0xffEEEEEE),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Text(
              '${DateFormat('EEE,d/M,y').format(note.date)} at ${DateFormat('jm').format(note.date)}',
              style: TextStyle(
                color: Color(0xffEEEEEE),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
