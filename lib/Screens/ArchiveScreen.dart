import 'package:flutter/material.dart';
import 'package:to_do_app/Widgets/EventArchiveList.dart';
import 'package:to_do_app/Widgets/NoteArchieveList.dart';
import 'package:to_do_app/Widgets/PageHeader.dart';
import 'package:to_do_app/Widgets/SideNavigationDrawer.dart';
import 'package:to_do_app/Widgets/TaskArchieveList.dart';
import 'package:to_do_app/constants.dart';

class ArchiveScreen extends StatefulWidget {
  static String archiveScreenID = "ArchiveScreen";

  @override
  _ArchiveScreenState createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> {
  Widget _determineSubPage() {
    if (page == 0) {
      return TaskArchieveList();
    } else if (page == 1) {
      return EventArchiveList();
    } else {
      return NoteArchieveList();
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
            PageHeader(pageName: 'Archieve'),
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
                padding: EdgeInsets.symmetric(horizontal: 20),
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

class TopBarSelectors extends StatelessWidget {
  final Function onPressed;
  final bool colorCondition;
  final IconData iconData;
  TopBarSelectors(
      {@required this.onPressed,
      @required this.colorCondition,
      @required this.iconData});
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      shape: CircleBorder(),
      onPressed: onPressed,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: colorCondition
            ? BoxDecoration(
                color: Color(0xffEEEEEE),
                borderRadius: BorderRadius.circular(20))
            : null,
        child: Icon(
          iconData,
          color: colorCondition ? Color(0xff222831) : Color(0xffEEEEEE),
        ),
      ),
    );
  }
}
