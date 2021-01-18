import 'package:flutter/material.dart';
import 'package:to_do_app/Widgets/EventsLists/EventBinList.dart';
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
    }
    else if(page == 1){
      return EventBinList();
    }
    else{
      return Container();
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
                  TopBarSelectors(
                    iconData: Icons.list,
                    colorCondition: (page == 0),
                    onPressed: () {
                      setState(() {
                        page = 0;
                      });
                    },
                  ),
                  TopBarSelectors(
                    iconData: Icons.event,
                    colorCondition: (page == 1),
                    onPressed: () {
                      setState(() {
                        page = 1;
                      });
                    },
                  ),
                  TopBarSelectors(
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
