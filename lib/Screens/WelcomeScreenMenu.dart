import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/Screens/TaskScreen.dart';
import 'package:to_do_app/Screens/WelcomeTaskScreen.dart';
import 'package:to_do_app/Screens/loginScreen.dart';
import 'package:to_do_app/models/DataFirebase.dart';

class WelcomeMenu extends StatefulWidget {
  static String id = 'welcomeMenu';

  @override
  _WelcomeMenuState createState() => _WelcomeMenuState();
}

class _WelcomeMenuState extends State<WelcomeMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff222831),
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
