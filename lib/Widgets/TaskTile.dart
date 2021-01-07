import 'package:flutter/material.dart';
import 'package:focused_menu/modals.dart';
import 'package:to_do_app/models/Tasks.dart';
import 'package:focused_menu/focused_menu.dart';

class TaskTile extends StatelessWidget {
  final Task theTask;
  final Function checkBoxCallBack;
  final Function longPressToDelete;
  final List<FocusedMenuItem> menu;
  TaskTile(
      {@required this.theTask,
      @required this.checkBoxCallBack,
      @required this.longPressToDelete,
      @required this.menu});
  @override
  Widget build(BuildContext context) {
    return FocusedMenuHolder(
      onPressed: () {},
      menuItems: menu,
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: 10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: (theTask.getState()) ? Color(0xffA7DBDD) : Color(0xffB1B3B5),
        ),
        child: ListTile(
          title: Text(
            theTask.getTask(),
            style: TextStyle(
              color: Color(0xff222831),
              decoration:
                  theTask.getState() ? TextDecoration.lineThrough : null,
            ),
          ),
          trailing: Checkbox(
            activeColor: Color(0xffA7DBDD),
            value: theTask.getState(),
            onChanged: checkBoxCallBack,
          ),
        ),
      ),
    );
  }
}
