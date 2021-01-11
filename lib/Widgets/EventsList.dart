import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/Widgets/EventTile.dart';
import 'package:to_do_app/main.dart';
import 'package:to_do_app/models/DataEvents.dart';
import 'package:to_do_app/models/DataFirebase.dart';

class EventsList extends StatelessWidget {
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
                  color: (eventsList.events[index].eventStatus())
                      ? Colors.orange[300]
                      : Colors.green,
                ),
                child: (eventsList.events[index].eventStatus())
                    ? Icon(
                        Icons.pending_actions,
                        color: Colors.white,
                      )
                    : Icon(
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
                if (direction == DismissDirection.endToStart) {
                  Provider.of<FirebaseController>(context, listen: false)
                      .deleteEvent(eventsList.events[index].title);
                  eventsList.removeEvent(index);
                } else {
                  eventsList.toggleStatus(index);
                  Provider.of<FirebaseController>(context, listen: false)
                      .toggleStatusEvents(eventsList.events[index].title,
                          eventsList.events[index].eventStatus());
                }
                await localNotificationsPlugin
                    .cancel(eventsList.events[index].id());
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
