import 'package:flutter/material.dart';
import 'package:to_do_app/constants.dart';
import 'package:to_do_app/models/Tasks.dart';

class EditAddTaskScreen extends StatelessWidget {
  final String type;
  final Function functionnality;
  EditAddTaskScreen({@required this.type, @required this.functionnality});
  @override
  Widget build(BuildContext context) {
    String newTask = '';
    return Container(
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
                  'Add a task',
                  style: TextStyle(
                      color: Color(0xff8ADFCB),
                      fontSize: 30,
                      fontWeight: FontWeight.w400),
                ),
                InkWell(
                  onTap: () {
                    Task taskToadd = Task(task: newTask);
                    functionnality(taskToadd);
                  },
                  child: CircleAvatar(
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    backgroundColor: kmainColor,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              autofocus: true,
              onChanged: (value) {
                newTask = value;
              },
              decoration: kTextFieldDecoration.copyWith(hintText: 'Task'),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
