import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:to_do_app/constants.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/models/DataEvents.dart';
import 'package:to_do_app/Widgets/CustomStartEndWidget.dart';
import 'package:to_do_app/models/Event.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/main.dart';
import 'dart:math';

class AddEventsSheet extends StatelessWidget {
  final Function functionality;

  AddEventsSheet({
    @required this.functionality,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<EventsController>(builder: (context, event, child) {
      return Container(
        child: Container(
          color: Color(0xff757575),
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: kRoundedContainerDecorator.copyWith(
              color: Theme.of(context).primaryColorDark,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Add an event',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 30,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        Event newEvent = Event(
                          event.tempEvent.title,
                          event.tempEvent.dateStart,
                          event.tempEvent.dateEnd,
                          0,
                          0,
                        );
                        Random random = new Random.secure();
                        int randomID = random.nextInt(10000);
                        newEvent.setId = randomID;
                        newEvent.setId2 = randomID + 10000;
                        functionality(newEvent);
                        await showAlertDialog(
                          context: context,
                          title: 'Reminder',
                          message:
                              'The application will notify you one day before the event and 30min before the event',
                        );
                        await _createNotification(newEvent);
                      },
                      child: CircleAvatar(
                        child: Icon(
                          Icons.add,
                          color: Color(0xffEEEEEE),
                        ),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  autofocus: true,
                  onChanged: (value) {
                    event.setTitle(value);
                  },
                  decoration: (Theme.of(context).brightness == Brightness.dark)
                      ? kTextFieldDecoration.copyWith(
                          hintText: 'Title',
                          hintStyle: TextStyle(
                            color: Color(0xffEEEEEE),
                          ),
                        )
                      : kTextFieldDecoration.copyWith(
                          hintText: 'Title',
                          hintStyle: TextStyle(
                            color: Color(0xff222831),
                          ),
                        ),
                ),
                SizedBox(
                  height: 10,
                ),
                CustomStartEndWidget(
                  name: 'Start',
                  onPressed: () async {
                    DateTime date = await showDatePicker(
                      context: context,
                      firstDate: DateTime(DateTime.now().year - 5),
                      lastDate: DateTime(DateTime.now().year + 5),
                      initialDate: event.getStartDate(),
                      initialDatePickerMode: DatePickerMode.day,
                    );
                    TimeOfDay time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (time != null && date != null) {
                      DateTime startingDate = new DateTime(
                        date.year,
                        date.month,
                        date.day,
                        time.hour,
                        time.minute,
                      );
                      event.setStartDate(startingDate);
                      print(startingDate);
                    }
                  },
                  date:
                      '${DateFormat('EEE,d/M,y').format(event.getStartDate())} at ${DateFormat('jm').format(event.getStartDate())}',
                ),
                SizedBox(
                  height: 5,
                ),
                CustomStartEndWidget(
                  name: 'End',
                  onPressed: () async {
                    DateTime date = await showDatePicker(
                      context: context,
                      firstDate: DateTime(DateTime.now().year - 5),
                      lastDate: DateTime(DateTime.now().year + 5),
                      initialDate: event.getEndDate(),
                      initialDatePickerMode: DatePickerMode.day,
                    );

                    TimeOfDay time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (time != null && date != null) {
                      DateTime endDate = new DateTime(
                        date.year,
                        date.month,
                        date.day,
                        time.hour,
                        time.minute,
                      );
                      event.setEndDate(endDate);
                    }
                  },
                  date:
                      '${DateFormat('EEE,d/M,y').format(event.getEndDate())} at ${DateFormat('jm').format(event.getEndDate())}',
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

Future _createNotification(Event theEvent) async {
  var scheduledNotification = theEvent.dateStart.subtract(
    Duration(minutes: 30),
  );
  var scheduledNotification2 = theEvent.dateStart.subtract(
    Duration(days: 1),
  );
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    '30minBefore',
    '30minutesBefore',
    'channelReminder30minBefore',
    importance: Importance.high,
    priority: Priority.high,
  );
  var platformSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );
  await localNotificationsPlugin.schedule(
    theEvent.id(),
    'You have an event coming',
    'You have ${theEvent.title} in 30 minutes',
    scheduledNotification,
    platformSpecifics,
    androidAllowWhileIdle: true,
  );
  await localNotificationsPlugin.schedule(
    theEvent.id2(),
    'You have an event coming',
    'You have ${theEvent.title} tomorrow',
    scheduledNotification2,
    platformSpecifics,
    androidAllowWhileIdle: true,
  );
}
