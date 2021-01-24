import 'package:flutter/material.dart';
import 'package:to_do_app/Screens/WelcomeEventsScreen.dart';
import 'package:to_do_app/Screens/loginScreen.dart';

class WelcomeTaskScreen extends StatelessWidget {
  static String id = 'welcomeTask';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onPanUpdate: (details) {
            if (details.delta.dx < 0) {
              Navigator.pushNamed(context, WelcomeEventScreeen.id);
            } else if (details.delta.dx > 0) {
              Navigator.pop(context);
            }
          },
          child: Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Set up task ',
                  style: TextStyle(
                    color: Color(0xffEEEEEE),
                    fontFamily: 'Pacifico',
                    fontSize: 30,
                  ),
                ),
                Text(
                  'With assistant you can set up tasks, easily and have them saved in the app',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xffEEEEEE),
                    fontFamily: 'Ninito',
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Flexible(
                  child: AnimatedContainer(
                    margin: EdgeInsets.only(left: 20),
                    duration: Duration(milliseconds: 100),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Image(
                      image: AssetImage('assets/ScreensMockUp/taskScreen.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
