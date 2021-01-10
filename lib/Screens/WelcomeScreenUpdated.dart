import 'package:flutter/material.dart';
import 'package:to_do_app/Widgets/CustomButtonWidget.dart';
import 'loginScreen.dart';
import 'registationScreen.dart';

class WelcomeScreenNew extends StatelessWidget {
  static String welcomeScreenID = 'welcomeScreenid';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/background.jpg',
            ),
            fit: BoxFit.fill,
            scale: 2,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Flexible(
                  child: Text(
                    'Welcome to your student companion',
                    style: TextStyle(
                      fontSize: 36,
                      fontFamily: 'Pacifico',
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
