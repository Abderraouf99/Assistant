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
  int _currentIndex = 0;
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        backgroundColor: Theme.of(context).primaryColorDark,
        elevation: 20,
        onTap: (value) {
          setState(
            () {
              _currentIndex = value;
              _controller.jumpToPage(_currentIndex);
            },
          );
        },
        items: [
          BottomNavigationBarItem(
            label: 'Tasks',
            icon: Icon(Icons.list),
          ),
          BottomNavigationBarItem(
            label: 'Events',
            icon: Icon(Icons.event),
          ),
        ],
      ),
      body: PageView(
        onPageChanged: (value) {
          setState(
            () {
              _currentIndex = value;
            },
          );
        },
        controller: _controller,
        children: [
          TasksScreen(),
          EventsScreen(),
        ],
      ),
    );
  }
}
