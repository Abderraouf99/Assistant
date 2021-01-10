import 'package:flutter/material.dart';
import 'package:to_do_app/Screens/EditAddTaskScreen.dart';
import 'package:to_do_app/Screens/EventsScreen.dart';
import 'package:to_do_app/Widgets/TaskList.dart';
import 'package:to_do_app/constants.dart';
import 'package:to_do_app/models/DataFirebase.dart';
import 'package:to_do_app/models/DataTask.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/models/Tasks.dart';
import 'WelcomeScreenUpdated.dart';

class TasksScreen extends StatelessWidget {
  static String taskScreenId = 'taskScreen';

  Widget _buildBottomSheet(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: EditAddTaskScreen(
          type: 'Add',
          functionnality: (Task taskToadd) async {
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

  @override
  Widget build(BuildContext context) {
    final currentUser =
        Provider.of<FirebaseController>(context).getAuthInstance().currentUser;

    return Scaffold(
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
            Container(
              padding:
                  EdgeInsets.only(left: 30, top: 25, bottom: 30, right: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PopupMenuButton(
                    offset: Offset(0, 110),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: FlatButton(
                          onPressed: () {
                            Provider.of<FirebaseController>(context,
                                    listen: false)
                                .getAuthInstance()
                                .signOut();
                            Navigator.popAndPushNamed(
                                context, WelcomeScreenNew.welcomeScreenID);
                          },
                          child: Row(
                            children: [
                              Icon(Icons.logout),
                              SizedBox(
                                width: 5,
                              ),
                              Text('Log out'),
                            ],
                          ),
                        ),
                      )
                    ],
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: (currentUser.photoURL != null)
                              ? NetworkImage(currentUser.photoURL)
                              : AssetImage(
                                  'assets/avataaars.png',
                                ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Tasks',
                    style: TextStyle(
                      fontFamily: 'Pacifico',
                      color: Color(0xffEEEEEE),
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20,
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
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TasksList(),
                decoration: kRoundedContainerDecorator.copyWith(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
