import 'package:flutter/material.dart';
import 'package:to_do_app/Widgets/EventsLists/EventBinList.dart';
import 'package:to_do_app/Widgets/NotesList/NoteBinList.dart';
import 'package:to_do_app/Widgets/PageHeader.dart';
import 'package:to_do_app/Widgets/SideNavigationDrawer.dart';
import 'package:to_do_app/Widgets/TasksLists/TaskBinList.dart';

import '../constants.dart';

class BinScreen extends StatefulWidget {
  static String id = "BinScreenID";

  @override
  _BinScreenState createState() => _BinScreenState();
}

class _BinScreenState extends State<BinScreen>
    with SingleTickerProviderStateMixin {
  TabController controller;
  @override
  void initState() {
    super.initState();
    controller = TabController(vsync: this, length: myTabs.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerCustom(),
      appBar: AppBar(
        title: PageHeader(pageName: 'Bin'),
        bottom: TabBar(
          tabs: myTabs,
          controller: controller,
        ),
      ),
      body: TabBarView(
        controller: controller,
        children: [
          TaskBinList(),
          EventBinList(),
          NoteBinList(),
        ],
      ),
    );
  }
}
