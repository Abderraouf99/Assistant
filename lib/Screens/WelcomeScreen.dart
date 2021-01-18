import 'package:flutter/material.dart';
import 'package:to_do_app/Screens/WelcomeEventsScreen.dart';
import 'package:to_do_app/Screens/WelcomePageNotes.dart';
import 'package:to_do_app/Screens/WelcomeScreenMenu.dart';
import 'package:to_do_app/Screens/WelcomeTaskScreen.dart';

class WelcomeScreenNew extends StatefulWidget {
  static String welcomeScreenID = 'welcomeScreenid';

  @override
  _WelcomeScreenNewState createState() => _WelcomeScreenNewState();
}

class _WelcomeScreenNewState extends State<WelcomeScreenNew> {
  final controller = PageController(initialPage: 0);
  int page = 0;
  void _nextFunction() {
    if (page <= 3) {
      setState(() {
        page++;
      });
    } else {
      setState(() {
        page = 0;
      });
    }
  }

  void _backFunction() {
    if (page >= 0) {
      setState(() {
        page--;
      });
    } else {
      setState(() {
        page = 0;
      });
    }
  }

  Widget _determinePage() {
    if (page == 0) {
      return WelcomeTaskScreen(
        nextFunction: _nextFunction,
      );
    } else if (page == 1) {
      return WelcomeEventScreeen(
        nextFunction: _nextFunction,
        backFuntion: _backFunction,
      );
    } else {
      return WelcomeNoteScreen(
        backFuntion: _backFunction,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView.builder(
          controller: controller,
          itemBuilder: (context, index) {
            return _determinePage();
          },
          onPageChanged: (index) {
            setState(() {
              page = index;
            });
          },
        ),
      ),
    );
  }
}
