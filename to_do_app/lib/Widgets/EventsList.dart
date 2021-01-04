import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/Widgets/EventTile.dart';
import 'package:to_do_app/models/DataEvents.dart';
import 'package:to_do_app/models/DataFirebase.dart';

class EventsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<EventsController>(
      builder: (context, eventsList, child) {
        return ListView.builder(
          itemBuilder: (context, index) {
            return EventTile(
              theEvent: eventsList.events[index],
              delete: () {
                Provider.of<FirebaseController>(context, listen: false)
                    .deleteEvent(eventsList.events[index].title);
                eventsList.removeEvent(index);
              },
              markAsDone: () {
                eventsList.toggleStatus(index);
                Provider.of<FirebaseController>(context, listen: false)
                    .toggleStatusEvents(eventsList.events[index].title,
                        eventsList.events[index].eventStatus);
              },
            );
          },
          itemCount: eventsList.events.length,
        );
      },
    );
  }
}
