import 'package:flutter/material.dart';
import 'package:to_do_app/constants.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/models/Data.dart';
import 'package:to_do_app/Widgets/CustomStartEndWidget.dart';

class AddEventsSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                    onTap: () {},
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
                onChanged: (value) {},
                decoration: textFieldDecoration.copyWith(hintText: 'Title'),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                onChanged: (value) {},
                decoration: textFieldDecoration.copyWith(hintText: 'Location'),
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
                    initialDate: Provider.of<Controller>(context, listen: false)
                        .getStartDate(),
                    initialDatePickerMode: DatePickerMode.day,
                  );
                  if (date != null) {
                    Provider.of<Controller>(context, listen: false)
                        .setStartDate(date);
                    print(date);
                  }
                  TimeOfDay selected = await showTimePicker(
                      context: context,
                      initialTime:
                          Provider.of<Controller>(context, listen: false)
                              .getSelectedTime());
                  if (selected != null) {
                    Provider.of<Controller>(context, listen: false)
                        .setTime(selected);
                  }
                },
                date: '${Provider.of<Controller>(context).getStartDate()}',
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
                    initialDate: Provider.of<Controller>(context, listen: false)
                        .getSelectedEndDate(),
                    initialDatePickerMode: DatePickerMode.day,
                  );
                  if (date != null) {
                    Provider.of<Controller>(context, listen: false)
                        .setEndDate(date);
                    print(date);
                  }
                  TimeOfDay selected = await showTimePicker(
                    context: context,
                    initialTime: Provider.of<Controller>(context, listen: false)
                        .getTimeofDayEnd(),
                  );
                  if (selected != null) {
                    Provider.of<Controller>(context, listen: false)
                        .setTimeOfEnd(selected);
                  }
                },
                date:
                    '${Provider.of<Controller>(context, listen: true).getSelectedEndDate()}',
              ),
              ListTile(
                leading: Text(
                  'Set a reminder',
                ),
                trailing: Switch(
                  activeColor: kmainColor,
                  value: true,
                  onChanged: (value) {
                    //Show a datePicker
                    //Show a timePicker
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/**
 * () async {
        
 */
