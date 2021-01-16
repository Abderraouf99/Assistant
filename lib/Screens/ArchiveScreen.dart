import 'package:flutter/material.dart';
import 'package:to_do_app/Widgets/EventArchiveList.dart';
import 'package:to_do_app/Widgets/NoteArchieveList.dart';
import 'package:to_do_app/Widgets/NotesList.dart';
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
                  FlatButton(
                    autofocus: true,
                    child: Icon(
                      Icons.list,
                      color: Color(0xffEEEEEE),
                    ),
                    onPressed: () {
                      setState(() {
                        page = 0;
                      });
                    },
                  ),
                  FlatButton(
                    child: Icon(
                      Icons.event,
                      color: Color(0xffEEEEEE),
                    ),
                    onPressed: () {
                      setState(() {
                        page = 1;
                      });
                    },
                  ),
                  FlatButton(
                    child: Icon(
                      Icons.note,
                      color: Color(0xffEEEEEE),
                    ),
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
