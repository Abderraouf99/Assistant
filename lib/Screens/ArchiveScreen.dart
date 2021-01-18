import 'package:flutter/material.dart';
import 'package:to_do_app/Widgets/EventsLists/EventArchiveList.dart';
import 'package:to_do_app/Widgets/TasksLists/TaskArchieveList.dart';
import 'package:to_do_app/Widgets/NotesList/NoteArchieveList.dart';

import 'package:to_do_app/Widgets/PageHeader.dart';
import 'package:to_do_app/Widgets/SideNavigationDrawer.dart';
import 'package:to_do_app/Widgets/TopBarSelectors.dart';
import 'package:to_do_app/constants.dart';

class ArchiveScreen extends StatefulWidget {
  static String archiveScreenID = "ArchiveScreen";

  @override
  _ArchiveScreenState createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> {
  Widget _determineSubPage() {
    if (page == 0) {
      return TaskArchiveList();
    } else if (page == 1) {
      return EventArchiveList();
    } else {
      return NoteArchiveList();
    }
  }

  int page = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerCustom(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PageHeader(pageName: 'Archive'),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TopBarSelectors(
                    title: 'Tasks',
                    iconData: Icons.list,
                    colorCondition: (page == 0),
                    onPressed: () {
                      setState(() {
                        page = 0;
                      });
                    },
                  ),
                  TopBarSelectors(
                    title: 'Events',
                    iconData: Icons.event,
                    colorCondition: (page == 1),
                    onPressed: () {
                      setState(() {
                        page = 1;
                      });
                    },
                  ),
                  TopBarSelectors(
                    title: 'Notes',
                    iconData: Icons.note,
                    colorCondition: (page == 2),
                    onPressed: () {
                      setState(() {
                        page = 2;
                      });
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: _determineSubPage(),
                padding: EdgeInsets.symmetric(horizontal: 10),
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


