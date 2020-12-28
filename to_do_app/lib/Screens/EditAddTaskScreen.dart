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
            Text(
              'Add a task',
              style: TextStyle(
                  color: Color(0xff8ADFCB),
                  fontSize: 30,
                  fontWeight: FontWeight.w400),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              autofocus: true,
              onChanged: (value) {
                newTask = value;
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10),
                hintText: 'Type your task here',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.lightBlueAccent,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.lightBlueAccent,
                  ),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.lightBlueAccent,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              child: InkWell(
                onTap: () {
                  Task taskToadd = Task(task: newTask);
                  functionnality(taskToadd);
                },
                child: Container(
                  padding: EdgeInsets.fromLTRB(50, 20, 50, 20),
                  decoration: BoxDecoration(
                    color: Color(0xff8ADFCB),
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                  ),
                  child: Text(
                    type,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
