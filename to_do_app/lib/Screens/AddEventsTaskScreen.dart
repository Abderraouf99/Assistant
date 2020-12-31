import 'package:flutter/material.dart';
import 'package:to_do_app/constants.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/models/DataEvents.dart';
import 'package:to_do_app/Widgets/CustomStartEndWidget.dart';
import 'package:to_do_app/models/Event.dart';
import 'package:intl/intl.dart';

class AddEventsSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<EventsController>(builder: (context, event, child) {
      return Container(
        child: Container(
          color: Color(0xff757575),
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: kRoundedContainerDecorator,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Add an event',
                      style: TextStyle(
                        color: kmainColor,
                        fontSize: 30,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        var newEvent = Event(
                            event.getTitle(),
                            event.getStartDate(),
                            event.getSelectedEndDate(),
                            event.getSelectedTime(),
                            event.getTimeofDayEnd(),
                            false);

                        event.addEvent(newEvent);
                      },
                      child: CircleAvatar(
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        backgroundColor: kmainColor,
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
                  decoration: kTextFieldDecoration.copyWith(hintText: 'Title'),
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
                    if (date != null) {
                      event.setStartDate(date);
                      print(date);
                    }
                    TimeOfDay selected = await showTimePicker(
                        context: context, initialTime: event.getSelectedTime());
                    if (selected != null) {
                      event.setTime(selected);
                    }
                  },
                  date:
                      '${DateFormat('EEE,d/M,y').format(event.getStartDate())} at ${event.getSelectedTime().hour}:${event.getSelectedTime().minute}',
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
                      initialDate: event.getSelectedEndDate(),
                      initialDatePickerMode: DatePickerMode.day,
                    );
                    if (date != null) {
                      event.setEndDate(date);
                      print(date);
                    }
                    TimeOfDay selected = await showTimePicker(
                      context: context,
                      initialTime: event.getTimeofDayEnd(),
                    );
                    if (selected != null) {
                      event.setTimeOfEnd(selected);
                    }
                  },
                  date:
                      '${DateFormat('EEE,d/M,y').format(event.getSelectedEndDate())} at ${event.getTimeofDayEnd().hour}:${event.getTimeofDayEnd().minute}',
                ),
                ListTile(
                  leading: Text(
                    'Set a reminder',
                  ),
                  trailing: Switch(
                    activeColor: kmainColor,
                    value: event
                        .remindedStatus, //TO DO : handle the being reminded Feature
                    onChanged: (value) {
                      event.toggleTobeReminded();
                      //TODO: Show a datePicker
                      //TODO :Show a timePicker
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

/**
 * () async {
        
 */
