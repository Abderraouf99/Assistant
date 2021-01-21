import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/Screens/ArchiveScreen.dart';
import 'package:to_do_app/Screens/BinScreen.dart';
import 'package:to_do_app/Screens/EventScreenCalendarView.dart';
import 'package:to_do_app/Screens/NotesScreen.dart';
import 'package:to_do_app/Screens/TaskScreen.dart';
import 'package:to_do_app/Screens/WelcomeScreenMenu.dart';
import 'package:to_do_app/models/DataFirebase.dart';

class DrawerCustom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 20,
            ),
            ListTile(
              leading: Image(
                image: AssetImage('assets/icon/icon.png'),
              ),
              title: Text(
                'Assistant',
                style: TextStyle(
                  fontFamily: 'Pacifico',
                  fontSize: 20,
                ),
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.toc),
              title: Text(
                'Tasks',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Roboto',
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, TasksScreen.taskScreenId);
              },
            ),
            ListTile(
              leading: Icon(Icons.event),
              title: Text(
                'Events',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Roboto',
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, CalendarView.id);
              },
            ),
            ListTile(
              leading: Icon(Icons.note),
              title: Text(
                'Notes',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Roboto',
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, NoteScreen.noteScreenID);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.archive),
              title: Text(
                'Archive',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Roboto',
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, ArchiveScreen.archiveScreenID);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete_rounded),
              title: Text(
                'Bin',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Roboto',
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, BinScreen.id);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text(
                'Log out',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Roboto',
                ),
              ),
              onTap: () async {
                await Provider.of<FirebaseController>(context, listen: false)
                    .getAuthInstance()
                    .signOut();
                Navigator.popAndPushNamed(context, WelcomeMenu.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
