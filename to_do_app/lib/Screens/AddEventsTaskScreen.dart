import 'package:flutter/material.dart';
import 'package:to_do_app/constants.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/models/Data.dart';
import 'package:to_do_app/Widgets/CustomStartEndWidget.dart';
import 'package:to_do_app/models/Event.dart';

class AddEventsSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String title = '';
    return Consumer<Controller>(builder: (context, event, child) {
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
                            title,
                            event.getStartDate(),
                            event.getSelectedEndDate(),
                            event.getSelectedTime(),
                            event.getTimeofDayEnd(),
                            event.toBeReminded);
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
                  onChanged: (value) {
                    title = value;
                  },
                  decoration: textFieldDecoration.copyWith(hintText: 'Title'),
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
                  date: '${event.getStartDate()}',
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
                  date: '${event.getSelectedEndDate()}',
                ),
                ListTile(
                  leading: Text(
                    'Set a reminder',
                  ),
                  trailing: Switch(
                    activeColor: kmainColor,
                    value: event.toBeReminded,
                    onChanged: (value) {
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
