import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/Widgets/DeleteDismissWidget.dart';
import 'package:to_do_app/Widgets/EventTile.dart';
import 'package:to_do_app/Widgets/RecoverDismissWidget.dart';
import 'package:to_do_app/models/DataEvents.dart';
import 'package:to_do_app/models/DataFirebase.dart';

class EventBinList extends StatelessWidget {
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
      builder: (context, events, child) {
        return ListView.builder(
          itemCount: (events.removed == null) ? 0 : events.removed.length,
          itemBuilder: (context, index) {
            return Dismissible(
              confirmDismiss: (direction) async {
                bool decision;
                if (direction == DismissDirection.endToStart) {
                  decision = await _showAlertDialog(context,
                      title: 'Purge event',
                      message:
                          'This event will be removed completely, and the assistant won\'t be able to retrieve it');
                } else {
                  decision = await _showAlertDialog(context,
                      title: 'Recover event',
                      message:
                          'This event will be moved back to the main event screen');
                }
                return decision;
              },
              secondaryBackground: DeleteDismissWidget(),
              background: RecoverDismissWidget(),
              onDismissed: (direction)async {
                if (direction == DismissDirection.endToStart) {
                 await Provider.of<FirebaseController>(context, listen: false)
                      .purgeEvent(events.removed[index]);
                  events.purgeEvent(index);
                } else {
                  await Provider.of<FirebaseController>(context, listen: false)
                      .recoverEvent(events.removed[index]);
                  events.recover(index);
                }
              },
              key: UniqueKey(),
              child: EventTile(
                theEvent: events.removed[index],
              ),
            );
          },
        );
      },
    );
  }
}
