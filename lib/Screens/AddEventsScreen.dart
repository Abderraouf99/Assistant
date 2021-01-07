import 'package:flutter/material.dart';
import 'package:to_do_app/constants.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/models/DataEvents.dart';
import 'package:to_do_app/Widgets/CustomStartEndWidget.dart';
import 'package:to_do_app/models/Event.dart';
import 'package:intl/intl.dart';

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
                        Event newEvent = Event(
                          event.tempEvent.title,
                          event.tempEvent.dateStart,
                          event.tempEvent.dateEnd,
                          event.tempEvent.toBereminded,
                        );
                        functionality(newEvent);
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
