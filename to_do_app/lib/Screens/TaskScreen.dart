import 'package:flutter/material.dart';
import 'package:to_do_app/Screens/EditAddTaskScreen.dart';
import 'package:to_do_app/Screens/WelcomeScreen.dart';
import 'package:to_do_app/Widgets/TaskList.dart';
import 'package:to_do_app/constants.dart';
import 'package:to_do_app/models/DataFirebase.dart';
import 'package:to_do_app/models/DataTask.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/models/Tasks.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

class TasksScreen extends StatelessWidget {
  static String taskScreenId = 'taskScreen';
  Widget buildBottomSheet(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: EditAddTaskScreen(
          type: 'Add',
          functionnality: (Task taskToadd) {
            Provider.of<ControllerTask>(context, listen: false)
                .addTasks(taskToadd);
            Provider.of<FirebaseController>(context, listen: false)
                .addTask(taskToadd);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  int getProgress(BuildContext context) {
    double completed = Provider.of<ControllerTask>(context)
        .getNumberOfTaskCompleted()
        .toDouble();
    double total =
        Provider.of<ControllerTask>(context).getNumberOfTasks().toDouble();
    if (total == 0) {
      return 0;
    }
    double result = (completed / total) * 100;
    return result.toInt();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff8ADFCB),
        elevation: 3,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () async {
          await showModalBottomSheet(
              context: context,
              builder: buildBottomSheet,
              isScrollControlled: true);
        },
      ),
      backgroundColor: Color(0xff8ADFCB),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding:
                  EdgeInsets.only(left: 30, top: 25, bottom: 30, right: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 30,
                        child: Icon(
                          Icons.school,
                          size: 30,
                          color: Color(0xff8ADFCB),
                        ),
                      ),
                      FlatButton(
                        onPressed: () {
                          Provider.of<FirebaseController>(context,
                                  listen: false)
                              .getAuthInstance()
                              .signOut();
                          Navigator.popAndPushNamed(
                              context, WelcomeScreen.welcomeScreenID);
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 30,
                          child: Icon(
                            Icons.logout,
                            size: 30,
                            color: Color(0xff8ADFCB),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'To-do',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Text(
                        '${Provider.of<ControllerTask>(context).getNumberOfTasks()} tasks',
                        style: kTaskPreviewTextStyle,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        '${Provider.of<ControllerTask>(context).getNumberOfTaskCompleted()} tasks completed',
                        style: kTaskPreviewTextStyle,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FAProgressBar(
                    currentValue: getProgress(context),
                    progressColor: Color(0xffA2EEDC),
                    displayText: '% ',
                    displayTextStyle:
                        TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TasksList(),
                decoration: kRoundedContainerDecorator,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
