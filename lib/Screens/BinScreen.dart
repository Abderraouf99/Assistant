import 'package:flutter/material.dart';
import 'package:to_do_app/Widgets/EventsLists/EventBinList.dart';
import 'package:to_do_app/Widgets/NotesList/NoteBinList.dart';
import 'package:to_do_app/Widgets/PageHeader.dart';
import 'package:to_do_app/Widgets/SideNavigationDrawer.dart';
import 'package:to_do_app/Widgets/TasksLists/TaskBinList.dart';
import 'package:to_do_app/Widgets/TopBarSelectors.dart';

import '../constants.dart';

class BinScreen extends StatefulWidget {
  static String id = "BinScreenID";

  @override
  _BinScreenState createState() => _BinScreenState();
}

class _BinScreenState extends State<BinScreen> {
  Widget _determineSubPage() {
    if (page == 0) {
      return TaskBinList();
    } else if (page == 1) {
      return EventBinList();
    } else {
      return NoteBinList();
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
            PageHeader(pageName: 'Bin'),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Container(
                      decoration: (page == 0)
                          ? BoxDecoration(
                              color: Color(0xffEEEEEE),
                              borderRadius: BorderRadius.circular(5),
                            )
                          : null,
                      child: TopBarSelectors(
                        title: 'Tasks',
                        iconData: Icons.list,
                        colorCondition: (page == 0),
                        onPressed: () {
                          setState(() {
                            page = 0;
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: (page == 1)
                          ? BoxDecoration(
                              color: Color(0xffEEEEEE),
                              borderRadius: BorderRadius.circular(5),
                            )
                          : null,
                      child: TopBarSelectors(
                        title: 'Events',
                        iconData: Icons.event,
                        colorCondition: (page == 1),
                        onPressed: () {
                          setState(() {
                            page = 1;
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: (page == 2)
                          ? BoxDecoration(
                              color: Color(0xffEEEEEE),
                              borderRadius: BorderRadius.circular(5),
                            )
                          : null,
                      child: TopBarSelectors(
                        title: 'Notes',
                        iconData: Icons.note,
                        colorCondition: (page == 2),
                        onPressed: () {
                          setState(() {
                            page = 2;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: _determineSubPage(),
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
