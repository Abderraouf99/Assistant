import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/constants.dart';
import 'package:to_do_app/models/DataTask.dart';
import 'package:to_do_app/models/Tasks.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  Task _tempTask = Task();
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskController>(
      builder: (context, tasksController, child) {
        return Container(
          color: Color(0xff757575),
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: kRoundedContainerDecorator.copyWith(
                color: Theme.of(context).primaryColorDark),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Add a task',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 30,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        if (_tempTask.task != '') {
                          await tasksController.addTasks(_tempTask);
                          Navigator.pop(context);
                        } else {
                          await showAlertDialog(
                            context: context,
                            title: 'Empty task 😓',
                            message: 'You can\'t add an empty task ',
                          );
                        }
                      },
                      child: CircleAvatar(
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        backgroundColor: Theme.of(context).primaryColor,
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
                    _tempTask.setTask = value;
                  },
                  decoration: (Theme.of(context).brightness == Brightness.dark)
                      ? kTextFieldDecoration.copyWith(
                          hintText: 'Task',
                          focusColor: Color(0xffffbd69),
                          hintStyle: TextStyle(
                            color: Color(0xffEEEEEE),
                          ),
                        )
                      : kTextFieldDecoration.copyWith(
                          hintText: 'Task',
                          focusColor: Color(0xff222831),
                        ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
