import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:to_do_app/constants.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/models/DataEvents.dart';
import 'package:to_do_app/Widgets/CustomStartEndWidget.dart';
import 'package:to_do_app/models/Event.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/main.dart';

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
              color: Theme.of(context).primaryColor,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Add an event',
                      style: TextStyle(
                        color: Theme.of(context).primaryColorDark,
                        fontSize: 30,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Event newEvent = Event(
                          event.tempEvent.title,
                          event.tempEvent.dateStart,
                          event.tempEvent.dateEnd,
                          event.tempEvent.toBereminded,
                        );
                        functionality(newEvent);
                        _createNotification(event.getStartDate());
                      },
                      child: CircleAvatar(
                        child: Icon(
                          Icons.add,
                          color: Color(0xffEEEEEE),
                        ),
                        backgroundColor: Theme.of(context).primaryColorDark,
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

void _createNotification(DateTime time) async {
  var scheduledNotificationTime = time.subtract(
    Duration(days: 1),
  );

  var scheduledNotificationTime2 = time.subtract(
    Duration(minutes: 30),
  );
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'reminderNotification',
    'reminderNotification',
    'channelForreminderNotification',
    icon: 'appicon',
    importance: Importance.high,
    priority: Priority.high,
    showWhen: false,
  );

  var platformSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.schedule(
      0,
      'You have an event coming',
      'Get ready you have an event tomorrow',
      scheduledNotificationTime,
      platformSpecifics,
      androidAllowWhileIdle: true);
  await flutterLocalNotificationsPlugin.schedule(
      0,
      'You have an event coming',
      'Get ready you have an event in 30 minutes',
      scheduledNotificationTime2,
      platformSpecifics,
      androidAllowWhileIdle: true);
}
