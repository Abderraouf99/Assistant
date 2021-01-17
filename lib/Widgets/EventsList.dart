import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/Widgets/EventTile.dart';
import 'package:to_do_app/main.dart';
import 'package:to_do_app/models/DataEvents.dart';
import 'package:to_do_app/models/DataFirebase.dart';

class EventsList extends StatelessWidget {
  final bool _isArchived = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<EventsController>(
      builder: (context, eventsList, child) {
        return ListView.builder(
          itemBuilder: (context, index) {
            return Dismissible(
              background: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.green,
                ),
                child: Icon(
                  Icons.done,
                  color: Colors.white,
                ),
              ),
              secondaryBackground: Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              onDismissed: (direction) async {
                await localNotificationsPlugin
                    .cancel(eventsList.events[index].id());
                if (direction == DismissDirection.endToStart) {
                  await Provider.of<FirebaseController>(context, listen: false)
                      .moveEventToBin(eventsList.events[index], _isArchived);
                  eventsList.moveToBin(index, _isArchived);
                } else {
                  eventsList.toggleStatus(index, _isArchived);
                  await Provider.of<FirebaseController>(context, listen: false)
                      .toggleStatusEvents(
                          eventsList.events[index], _isArchived);
                  await Provider.of<FirebaseController>(context, listen: false)
                      .archiveEvent(eventsList.events[index]);
                  eventsList.moveToArchive(index);
                }
              },
              key: UniqueKey(),
              child: EventTile(
                theEvent: eventsList.events[index],
              ),
            );
          },
          itemCount: (eventsList.events != null) ? eventsList.events.length : 0,
        );
      },
    );
  }
}
