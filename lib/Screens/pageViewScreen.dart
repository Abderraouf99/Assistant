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

  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColorDark,
        onTap: (value) {
          setState(() {
            currentIndex = value;
            _controller.jumpToPage(currentIndex);
          });
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
        controller: _controller,
        children: [
          TasksScreen(),
          EventsScreen(),
        ],
      ),
    );
  }
}
