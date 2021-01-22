import 'package:flutter/material.dart';
import 'package:to_do_app/models/Event.dart';
import 'package:intl/intl.dart';
import 'EventInfoTile.dart';

class EventTile extends StatelessWidget {
  final Event theEvent;

  EventTile({
    @required this.theEvent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            status: theEvent.status,
          ),
        ],
      ),
    );
  }
}
