import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:to_do_app/models/Event.dart';
import 'package:intl/intl.dart';
import 'EventInfoTile.dart';

class EventTile extends StatelessWidget {
  final Event theEvent;
  final Function delete;
  final Function markAsDone;

  EventTile({
    @required this.theEvent,
    @required this.delete,
    @required this.markAsDone,
  });

  @override
  Widget build(BuildContext context) {
    return FocusedMenuHolder(
      onPressed: () {},
      menuItems: [
        FocusedMenuItem(
          title: Row(
            children: [
              (theEvent.eventStatus) ? Icon(Icons.pending) : Icon(Icons.done),
              (theEvent.eventStatus)
                  ? Text('Mark as pending')
                  : Text('Mark as done'),
            ],
          ),
          onPressed: markAsDone,
        ),
        FocusedMenuItem(
          title: Row(
            children: [
              Icon(Icons.delete),
              Text('Delete'),
            ],
          ),
          onPressed: delete,
        ),
      ],
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 20,
        ),
        child: Row(
          children: [
            //DayWidget
            DayTile(
              month: '${DateFormat('MMM').format(theEvent.dateStart)}',
              day: '${theEvent.dateStart.day}',
            ),
            SizedBox(
              width: 10,
            ),
            EventInfoTile(
              title: '${theEvent.title}',
              startTime: '${DateFormat('jm').format(theEvent.dateStart)}',
              endTime: '${DateFormat('jm').format(theEvent.dateEnd)}',
              status: theEvent.eventStatus,
            ),
          ],
        ),
      ),
    );
  }
}
