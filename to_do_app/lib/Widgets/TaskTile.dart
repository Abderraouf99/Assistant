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
      child: ListTile(
        title: Text(
          theTask.getTask(),
          style: TextStyle(
            decoration: theTask.getState() ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: Checkbox(
          activeColor: Color(0xff8ADFCB),
          value: theTask.getState(),
          onChanged: checkBoxCallBack,
        ),
      ),
    );
  }
}
