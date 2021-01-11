import 'package:flutter/material.dart';
import 'package:to_do_app/Widgets/CustomButtonWidget.dart';
import 'loginScreen.dart';
import 'registationScreen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeScreenNew extends StatelessWidget {
  static String welcomeScreenID = 'welcomeScreenid';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/background.png',
            ),
            fit: BoxFit.cover,
            scale: 0.5,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Flexible(
                  child: TypewriterAnimatedTextKit(
                    text: [
                      'Assistant',
                      'Fast',
                      'Easy to use',
                      'Task and event app'
                    ],
                    textStyle: TextStyle(
                      fontSize: 35,
                      fontFamily: 'Pacifico',
                      color: Color(0xff162447),
                    ),
                  ),
                ),
                SizedBox(
                  height: 160,
                ),
                CustomButton(
                  backgroundColor: Color(0xff222831),
                  onTap: () {
                    Navigator.pushNamed(context, LoginScreen.loginScreenId);
                  },
                  name: 'Login',
                ),
                SizedBox(
                  height: 40,
                ),
                Opacity(
                  opacity: 0.5,
                  child: CustomButton(
                    backgroundColor: Color(0xff222831),
                    onTap: () {
                      Navigator.pushNamed(
                          context, RegistrationScreen.registrationScreenID);
                    },
                    name: 'Register',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
