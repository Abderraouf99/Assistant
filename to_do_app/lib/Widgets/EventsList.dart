import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/Widgets/EventTile.dart';
import 'package:to_do_app/models/DataEvents.dart';

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
                eventsList.removeEvent(index);
              },
              markAsDone: () {
                eventsList.toggleStatus(index);
              },
            );
          },
          itemCount: eventsList.events.length,
        );
      },
    );
  }
}
