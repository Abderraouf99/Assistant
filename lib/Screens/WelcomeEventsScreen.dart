import 'package:flutter/material.dart';
import 'package:to_do_app/Screens/WelcomePageNotes.dart';

class WelcomeEventScreeen extends StatelessWidget {
  static String id = 'WelcomeEventID';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff222831),
      body: SafeArea(
        child: GestureDetector(
          onPanUpdate: (details) {
            if (details.delta.dx > 0) {
              Navigator.pop(context);
            } else if (details.delta.dx < 0) {
              Navigator.pushNamed(context, WelcomeNoteScreen.id);
            }
          },
          child: Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Add your events ',
                  style: TextStyle(
                    color: Color(0xffEEEEEE),
                    fontFamily: 'Pacifico',
                    fontSize: 30,
                  ),
                ),
                Text(
                  'With assistant you can set up event easily and be reminded when the times comes',
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
                    decoration: BoxDecoration(),
                    child: Image(
                      image: AssetImage('assets/ScreensMockUp/eventScreen.png'),
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
