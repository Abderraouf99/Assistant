import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/constants.dart';
import 'package:to_do_app/models/Note.dart';
import 'package:intl/intl.dart';

class NoteTile extends StatelessWidget {
  final Note note;
  final Function deleteFunction;
  final Function archiveFunction;
  NoteTile(
      {@required this.note,
      @required this.deleteFunction,
      @required this.archiveFunction});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      background: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          Icons.archive,
          color: Colors.white,
        ),
      ),
      secondaryBackground: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          deleteFunction();
        } else {
          archiveFunction();
        }
      },
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          await showAlertDialog(
            context: context,
            title: 'Deleted notes',
            message: 'This note will be moved to the bin',
            barrierDismissible: false,
            actions: [
              AlertDialogAction(label: 'Confirm'),
            ],
          );
        } else {
          await showAlertDialog(
            context: context,
            title: 'Archived notes',
            message: 'This note will be moved to the archive',
            barrierDismissible: false,
            actions: [
              AlertDialogAction(label: 'Confirm'),
            ],
          );
        }
        return true;
      },
      key: UniqueKey(),
      child: InkWell(
        onTap: () {
          //ADD the show more details part
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: (Theme.of(context).brightness == Brightness.dark)
                ? Color(0xffffbd69)
                : Color(0xff30475e),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${note.getTitle}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xffEEEEEE),
                    ),
                  ),
                  Text(
                    '${DateFormat('EEE,d/M,y').format(note.getDate)} at ${DateFormat('jm').format(note.getDate)}',
                    style: TextStyle(
                      color: Color(0xffEEEEEE),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Divider(
                color: Color(0xffEEEEEE),
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
            ],
          ),
        ),
      ),
    );
  }
}
