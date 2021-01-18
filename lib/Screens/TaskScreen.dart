import 'package:flutter/material.dart';
import 'package:to_do_app/Screens/EditAddTaskScreen.dart';
import 'package:to_do_app/Widgets/PageHeader.dart';
import 'package:to_do_app/Widgets/SideNavigationDrawer.dart';
import 'package:to_do_app/Widgets/TasksLists/TaskList.dart';

import 'package:to_do_app/constants.dart';
import 'package:to_do_app/models/DataFirebase.dart';
import 'package:to_do_app/models/DataTask.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/models/Tasks.dart';

class TasksScreen extends StatelessWidget {
  static String taskScreenId = 'taskScreen';

  Widget _buildBottomSheet(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: EditAddTaskScreen(
          type: 'Add',
          function: (Task taskToadd) async {
            Provider.of<TaskController>(context, listen: false)
                .addTasks(taskToadd);
            Provider.of<FirebaseController>(context, listen: false)
                .addTask(taskToadd);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerCustom(),
      floatingActionButton: FloatingActionButton(
        elevation: 3,
        child: Icon(
          Icons.add,
          color: Color(0xffEEEEEE),
        ),
        onPressed: () async {
          await showModalBottomSheet(
              context: context,
              builder: _buildBottomSheet,
              isScrollControlled: true);
        },
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PageHeader(
              pageName: 'Tasks',
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TasksList(),
                decoration: kRoundedContainerDecorator.copyWith(
                  color: Theme.of(context).primaryColorDark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
