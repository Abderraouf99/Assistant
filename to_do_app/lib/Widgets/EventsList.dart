import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/Widgets/EventTile.dart';

import 'package:to_do_app/models/Data.dart';

class EventsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Controller>(builder: (context, eventsList, child) {
      return ListView.builder(
        itemBuilder: (context, index) {
          return EventTile(
            theEvent: eventsList.events[index],
            delete: () {
              eventsList.removeEvent(index);
            },
            markAsDone: () {
              eventsList.events[index].toggleStatus();
            },
            tagData: (eventsList.events[index].getStatus())
                ? Icons.done
                : Icons.pending,
          );
        },
        itemCount: eventsList.events.length,
      );
    });
  }
}
