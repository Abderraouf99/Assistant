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
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class AddEventsSheet extends StatefulWidget {
  final Function functionality;
  final DateTime selectedTime;

  AddEventsSheet({
    @required this.functionality,
    @required this.selectedTime,
  });

  @override
  _AddEventsSheetState createState() => _AddEventsSheetState();
}

class _AddEventsSheetState extends State<AddEventsSheet> {
  Event _tempEvent = Event();
  bool toBeReminded = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<EventsController>(
      builder: (context, event, child) {
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
                          String key = UniqueKey().toString();
                          int id = Random.secure().nextInt(10000);
                          _tempEvent.setID = id;
                          _tempEvent.setKey = key;
                          widget.functionality(_tempEvent);
                          await _createNotification(_tempEvent);
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
                    autocorrect: false,
                    autofocus: true,
                    onChanged: (value) {
                      _tempEvent.setTitle = value;
                    },
                    decoration:
                        (Theme.of(context).brightness == Brightness.dark)
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
                        initialDate: widget.selectedTime,
                        initialDatePickerMode: DatePickerMode.day,
                      );
                      if (date != null) {
                        TimeOfDay time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (time != null) {
                          DateTime startingDate = new DateTime(
                            date.year,
                            date.month,
                            date.day,
                            time.hour,
                            time.minute,
                          );
                          _tempEvent.setDayStarts = startingDate;
                        }
                      } else {
                        _tempEvent.setDayStarts = widget.selectedTime;
                      }
                    },
                    date:
                        '${DateFormat('EEE,d/M,y').format(_tempEvent.dateStart)} at ${DateFormat('jm').format(_tempEvent.dateStart)}',
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
                        initialDate: _tempEvent.dateStart,
                        initialDatePickerMode: DatePickerMode.day,
                      );
                      if (date != null) {
                        TimeOfDay time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (time != null) {
                          DateTime endDate = new DateTime(
                            date.year,
                            date.month,
                            date.day,
                            time.hour,
                            time.minute,
                          );
                          _tempEvent.setDayEnds = endDate;
                        }
                      } else {
                        _tempEvent.setDayEnds = _tempEvent.dateStart.add(
                          Duration(hours: 1),
                        );
                      }
                    },
                    date:
                        '${DateFormat('EEE,d/M,y').format(_tempEvent.dateEnd)} at ${DateFormat('jm').format(_tempEvent.dateEnd)}',
                  ),
                  ListTile(
                    leading: Text('Reminder'),
                    trailing: (_tempEvent.reminder == null)
                        ? Text('')
                        : Text(
                            '${DateFormat('EEE,d/M,y').format(_tempEvent.reminder)} at ${DateFormat('jm').format(_tempEvent.reminder)}'),
                    onTap: () async {
                      DateTime reminderDate = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: _tempEvent.dateEnd,
                        initialDate: DateTime.now(),
                        initialDatePickerMode: DatePickerMode.day,
                      );
                      if (reminderDate != null) {
                        TimeOfDay reminderTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (reminderTime != null) {
                          _tempEvent.setReminder = new DateTime(
                            reminderDate.year,
                            reminderDate.month,
                            reminderDate.day,
                            reminderTime.hour,
                            reminderTime.minute,
                          );
                          setState(() {
                            toBeReminded = true;
                          });
                        }
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future _createNotification(Event theEvent) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'EventNotification',
      'EventNotification',
      'EventNotification',
      importance: Importance.high,
      priority: Priority.high,
    );
    var platformSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    if (toBeReminded) {
      try {
        final String currentTimeZone =
            await FlutterNativeTimezone.getLocalTimezone();
        final timeZone = tz.getLocation(currentTimeZone);
        final scheduleNotification =
            tz.TZDateTime.from(theEvent.reminder, timeZone);
        await localNotificationsPlugin.zonedSchedule(
          theEvent.id,
          'You have an upcomig event',
          'Hey you have ${theEvent.title} coming up soon',
          scheduleNotification,
          platformSpecifics,
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
      } catch (e) {
        print(e);
      }
    }
  }
}
