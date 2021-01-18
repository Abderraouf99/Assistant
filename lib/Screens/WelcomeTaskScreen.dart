import 'package:flutter/material.dart';
import 'package:to_do_app/Screens/WelcomeEventsScreen.dart';
import 'package:to_do_app/Screens/loginScreen.dart';

class WelcomeTaskScreen extends StatelessWidget {
  static String id = 'welcomeTask';

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
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color(0xffEEEEEE),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Image(
                    image: AssetImage('assets/tasks.jpg'),
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
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: FlatButton(
                      child: Text('Skip'),
                      onPressed: () {
                        Navigator.popAndPushNamed(
                            context, LoginScreen.loginScreenId);
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
                        'Next',
                        style: TextStyle(
                          color: Color(0xffEEEEEE),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, WelcomeEventScreeen.id);
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
