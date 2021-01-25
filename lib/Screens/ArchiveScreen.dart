import 'package:flutter/material.dart';
import 'package:to_do_app/Widgets/EventsLists/EventArchiveList.dart';
import 'package:to_do_app/Widgets/TasksLists/TaskArchieveList.dart';
import 'package:to_do_app/Widgets/NotesList/NoteArchieveList.dart';

import 'package:to_do_app/Widgets/PageHeader.dart';
import 'package:to_do_app/Widgets/SideNavigationDrawer.dart';

import 'package:to_do_app/constants.dart';

class ArchiveScreen extends StatefulWidget {
  static String archiveScreenID = "ArchiveScreen";

  @override
  _ArchiveScreenState createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen>
    with SingleTickerProviderStateMixin {
  TabController controller;
  @override
  initState() {
    super.initState();
    controller = TabController(vsync: this, length: myTabs.length);
  }

  int page = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerCustom(),
      appBar: AppBar(
        title: PageHeader(pageName: 'Archive'),
        bottom: TabBar(
          controller: controller,
          tabs: myTabs,
        ),
      ),
      body: TabBarView(
        controller: controller,
        children: [
          TaskArchiveList(),
          EventArchiveList(),
          NoteArchiveList(),
        ],
      ),
    );
  }
}
