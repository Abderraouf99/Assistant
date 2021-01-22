import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/Widgets/EventTile.dart';
import 'package:to_do_app/main.dart';
import 'package:to_do_app/models/DataEvents.dart';

class EventsList extends StatelessWidget {
  final bool _isArchived = false;
  final DateTime selectedDate;
  EventsList({
    @required this.selectedDate,
  });
  Future<bool> _showAlertDialog(BuildContext context,
      {String title, String message}) async {
    bool choice = false;
    Widget cancelButton = TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: Text('Cancel'),
    );
    Widget okButton = TextButton(
      onPressed: () {
        choice = true;
        Navigator.pop(context);
      },
      child: Text('Ok'),
    );

    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [cancelButton, okButton],
    );

    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return alert;
        });
    return choice;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EventsController>(
      builder: (context, eventController, child) {
        return ListView.builder(
          itemBuilder: (context, index) {
            return Dismissible(
              confirmDismiss: (direction) async {
                bool decision;
                if (direction == DismissDirection.endToStart) {
                  decision = await _showAlertDialog(
                    context,
                    title: 'Event deleted',
                    message: 'Deleted events will be moved to the bin tab',
                  );
                } else {
                  decision = await _showAlertDialog(
                    context,
                    title: 'Event completed',
                    message:
                        'Completed events will be moved to the archive tab',
                  );
                }

                return decision;
              },
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
                    .cancel(eventController.setEvents[index].id);
                if (direction == DismissDirection.endToStart) {
                  await eventController.moveToBin(index, _isArchived);
                } else {
                  await eventController.toggleStatus(index, _isArchived);
                  await eventController.moveToArchive(index);
                }
              },
              key: UniqueKey(),
              child: EventTile(
                theEvent: eventController.getEventsAtDate(selectedDate)[index],
              ),
            );
          },
          itemCount: (eventController.getEventsAtDate(selectedDate) != null)
              ? eventController.getEventsAtDate(selectedDate).length
              : 0,
        );
      },
    );
  }
}
