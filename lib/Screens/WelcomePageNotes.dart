import 'package:flutter/material.dart';
import 'package:to_do_app/Screens/loginScreen.dart';

class WelcomeNoteScreen extends StatelessWidget {
  static String id = 'welcomeNote';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onPanUpdate: (details) {
            if (details.delta.dx < 0) {
              Navigator.pushNamed(context, LoginScreen.loginScreenId);
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
                  'Keep your notes ',
                  style: TextStyle(
                    color: Color(0xffEEEEEE),
                    fontFamily: 'Pacifico',
                    fontSize: 30,
                  ),
                ),
                Text(
                  'With assistant you can save you notes and have them in your pocket',
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
                    duration: Duration(milliseconds: 100),
                    margin: EdgeInsets.only(left: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Image(
                      image: AssetImage('assets/ScreensMockUp/NoteScreen.png'),
                      fit: BoxFit.cover,
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
