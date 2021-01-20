import 'package:flutter/material.dart';
import 'package:to_do_app/Screens/loginScreen.dart';

class WelcomeNoteScreen extends StatelessWidget {
  static String id = 'welcomeNote';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color(0xffEEEEEE),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Image(
                    image: AssetImage('assets/notes.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color :Color(0xffEEEEEE),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: FlatButton(
                      child: Text('Back'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xffff6363),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: FlatButton(
                      highlightColor: Colors.transparent,
                      child: Text(
                        'Continue',
                        style: TextStyle(
                          color: Color(0xffEEEEEE),
                        ),
                      ),
                      onPressed: () {
                        Navigator.popAndPushNamed(
                            context, LoginScreen.loginScreenId);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
