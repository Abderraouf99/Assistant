import 'package:flutter/material.dart';
import 'package:to_do_app/Screens/loginScreen.dart';
import 'package:to_do_app/Screens/registationScreen.dart';
import 'package:to_do_app/Widgets/CustomButtonWidget.dart';

class WelcomeScreen extends StatelessWidget {
  static String welcomeScreenID = 'WelcomeScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 100, 20, 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Hero(
                    tag: 'StudentTag',
                    child: Container(
                      child: Text(
                        '👨‍🎓️',
                        style: TextStyle(fontSize: 60),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      'Student\'s companion',
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 170,
              ),
              CustomButton(
                  backgroundColor: Color(0xff8ADFCB),
                  onTap: () {
                    Navigator.popAndPushNamed(
                        context, LoginScreen.loginScreenId);
                  },
                  name: 'Log in'),
              SizedBox(
                height: 19,
              ),
              CustomButton(
                  backgroundColor: Color(0xff6BAF9F),
                  onTap: () {
                    Navigator.popAndPushNamed(
                        context, RegistrationScreen.registrationScreenID);
                  },
                  name: 'Register')
            ],
          ),
        ),
      ),
    );
  }
}
