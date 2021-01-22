import 'package:flutter/material.dart';
import 'package:to_do_app/models/Tasks.dart';
import 'package:to_do_app/constants.dart';

class TaskTile extends StatelessWidget {
  final Task theTask;
  final Function checkBoxCallBack;

  TaskTile({
    @required this.theTask,
    this.checkBoxCallBack,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 5,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: determineColor(
          Theme.of(context).brightness,
          theTask.status,
        ),
      ),
      child: ListTile(
        title: Text(
          theTask.task,
          style: TextStyle(
            color: Color(0xffEEEEEE),
            decoration: theTask.status ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: Checkbox(
          activeColor: (Theme.of(context).brightness == Brightness.dark)
              ? Color(0xff51c2d5)
              : Color(0xff30475e),
          value: theTask.status,
          onChanged: checkBoxCallBack,
        ),
      ),
    );
  }
}
