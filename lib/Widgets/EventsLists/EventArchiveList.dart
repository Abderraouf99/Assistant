import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/Widgets/DeleteDismissWidget.dart';
import 'package:to_do_app/Widgets/EventTile.dart';
import 'package:to_do_app/Widgets/RecoverDismissWidget.dart';
import 'package:to_do_app/models/DataEvents.dart';

class EventArchiveList extends StatelessWidget {
  final bool _isArchived = true;
  @override
  Widget build(BuildContext context) {
    return Consumer<EventsController>(
      builder: (context, event, child) {
        return ListView.builder(
          itemCount: (event.archive == null) ? 0 : event.archive.length,
          itemBuilder: (context, index) {
            return Dismissible(
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.endToStart) {
                  await showAlertDialog(
                    context: context,
                    title: 'Deleted event',
                    message: 'Deleted event will be moved to the bin tab',
                    barrierDismissible: false,
                    actions: [
                      AlertDialogAction(label: 'Ok'),
                    ],
                  );
                } else {
                  await showAlertDialog(
                    context: context,
                    title: 'Unarchive event',
                    message:
                        'Unarchived event will be moved to the main event tab',
                    barrierDismissible: false,
                    actions: [
                      AlertDialogAction(label: 'Ok'),
                    ],
                  );
                }
                return true;
              },
              onDismissed: (direction) async {
                if (direction == DismissDirection.endToStart) {
                  await event.moveToBin(index, _isArchived);
                } else {
                  await event.unArchiveEvent(index);
                }
              },
              secondaryBackground: DeleteDismissWidget(),
              background: RecoverDismissWidget(),
              key: UniqueKey(),
              child: EventTile(
                theEvent: event.archive[index],
              ),
            );
          },
        );
      },
    );
  }
}
