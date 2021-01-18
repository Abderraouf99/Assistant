import 'package:flutter/material.dart';
import 'package:to_do_app/Screens/WelcomeTaskScreen.dart';
import 'package:to_do_app/Screens/loginScreen.dart';

class WelcomeMenu extends StatelessWidget {
  static String id = 'welcomeMenu';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hey,',
                    style: TextStyle(
                      fontSize: 45,
                      color: Color(0xffEEEEEE),
                      fontFamily: 'Nunito',
                    ),
                  ),
                  Text(
                    'Welcome',
                    style: TextStyle(
                      fontSize: 45,
                      color: Color(0xffEEEEEE),
                      fontFamily: 'Nunito',
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xffff6363),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: FlatButton(
                      highlightColor: Colors.transparent,
                      child: Text(
                        'Login / Register',
                        style: TextStyle(
                          color: Color(0xffEEEEEE),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, LoginScreen.loginScreenId);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Opacity(
                    opacity: 0.7,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xffffbd69),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: FlatButton(
                          highlightColor: Colors.transparent,
                          child: Text(
                            'See preview',
                            style: TextStyle(
                              color: Color(0xffEEEEEE),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, WelcomeTaskScreen.id);
                          }),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
