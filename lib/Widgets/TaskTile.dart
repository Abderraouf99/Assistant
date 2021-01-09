import 'package:flutter/material.dart';
import 'package:to_do_app/models/Tasks.dart';

class TaskTile extends StatelessWidget {
  final Task theTask;
  final Function checkBoxCallBack;

  TaskTile({
    @required this.theTask,
    @required this.checkBoxCallBack,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: (theTask.getState()) ? Color(0xffffbd69) : Color(0xffff6363),
      ),
      child: ListTile(
        title: Text(
          theTask.getTask(),
          style: TextStyle(
            color: Color(0xffEEEEEE),
            decoration: theTask.getState() ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: Checkbox(
          activeColor: Color(0xffffbd69),
          value: theTask.getState(),
          onChanged: checkBoxCallBack,
        ),
      ),
    );
  }
}
