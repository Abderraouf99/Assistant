import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:to_do_app/constants.dart';
import 'package:to_do_app/models/Event.dart';

class EventTile extends StatelessWidget {
  final Event theEvent;
  final Function delete;
  final Function markAsDone;
  final IconData tagData;
  EventTile(
      {@required this.theEvent,
      @required this.delete,
      @required this.markAsDone,
      @required this.tagData});
  @override
  Widget build(BuildContext context) {
    return FocusedMenuHolder(
      onPressed: () {},
      menuItems: [
        FocusedMenuItem(
          title: Row(
            children: [
              Icon(Icons.done),
              Text('Mark as done'),
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
          horizontal: 30,
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
              tag: tagData,
            ),
          ],
        ),
      ),
    );
  }
}

class EventInfoTile extends StatelessWidget {
  final String title;
  final IconData tag;
  final String startTime;
  final String endTime;
  EventInfoTile(
      {@required this.title,
      @required this.tag,
      @required this.startTime,
      @required this.endTime});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: kmainColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: eventTextStyle.copyWith(
                    color: Colors.white,
                  ),
                ),
                Icon(
                  tag,
                  color: Colors.white,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Starts at: $startTime ',
                  style: eventTextStyle.copyWith(
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Ends at: $endTime ',
                  style: eventTextStyle.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DayTile extends StatelessWidget {
  final String month;
  final String day;
  DayTile({@required this.month, @required this.day});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            month,
            style: eventTextStyle,
          ),
          Text(
            day,
            style: eventTextStyle,
          ),
        ],
      ),
    );
  }
}
