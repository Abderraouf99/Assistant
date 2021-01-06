import 'package:flutter/material.dart';
import 'package:to_do_app/Screens/EventsScreen.dart';
import 'package:to_do_app/Screens/TaskScreen.dart';

class PageViewNavigation extends StatefulWidget {
  static String pageViewNavigationID = 'PageViewScreen';
  @override
  _PageViewNavigationState createState() => _PageViewNavigationState();
}

class _PageViewNavigationState extends State<PageViewNavigation> {
  PageController _controller = PageController(
    initialPage: 0,
  );
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _controller,
      children: [
        TasksScreen(),
        EventsScreen(),
      ],
    );
  }
}