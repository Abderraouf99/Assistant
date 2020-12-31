import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:to_do_app/models/Event.dart';

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
              (theEvent.getStatus()) ? Icon(Icons.pending) : Icon(Icons.done),
              (theEvent.getStatus())
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
          vertical: 20,
          horizontal: 20,
        ),
        child: Row(
          children: [
            //DayWidget
            DayTile(
              month: '${theEvent.dateStart.month}',
              day: '${theEvent.dateStart.day}',
            ),
            SizedBox(
              width: 10,
            ),
            EventInfoTile(
              title: '${theEvent.title}',
              startTime:
                  '${theEvent.timeStart.hour}:${theEvent.timeStart.minute} ${(theEvent.timeStart.period == DayPeriod.am) ? 'am' : 'pm'}',
              endTime:
                  '${theEvent.timeEnds.hour}:${theEvent.timeEnds.minute} ${(theEvent.timeEnds.period == DayPeriod.am) ? 'am' : 'pm'}',
              status: theEvent.getStatus(),
            ),
          ],
        ),
      ),
    );
  }
}
