import 'package:flutter/material.dart';
import 'package:to_do_app/constants.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/models/Data.dart';

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
              Text(
                'Add an event',
                style: TextStyle(
                  color: kmainColor,
                  fontSize: 30,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                onChanged: (value) {},
                decoration: InputDecoration(
                  hintText: 'Title',
                ),
              ),
              TextField(
                onChanged: (value) {},
                decoration: InputDecoration(
                  hintText: 'Location',
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: FlatButton(
                      onPressed: () async {
                        DateTime date = await showDatePicker(
                          context: context,
                          firstDate: DateTime(DateTime.now().year - 5),
                          lastDate: DateTime(DateTime.now().year + 5),
                          initialDate: Provider.of<Data>(context, listen: false)
                              .getSelectedDate(),
                          initialDatePickerMode: DatePickerMode.day,
                        );
                        if (date != null) {
                          Provider.of<Data>(context, listen: false)
                              .setDate(date);
                          print(date);
                        }
                      },
                      child: Text(
                        'Enter date',
                      ),
                    ),
                  ),
                  Expanded(
                    child: FlatButton(
                      child: Text('Enter time'),
                      onPressed: () async {
                        TimeOfDay selected = await showTimePicker(
                            context: context,
                            initialTime:
                                Provider.of<Data>(context, listen: false)
                                    .getSelectedTime());
                        if (selected != null) {
                          Provider.of<Data>(context, listen: false)
                              .setTime(selected);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
