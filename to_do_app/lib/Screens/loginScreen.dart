import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/Screens/pageViewScreen.dart';
import 'package:to_do_app/Widgets/CustomButtonWidget.dart';
import 'package:to_do_app/Widgets/GoogleSignInButton.dart';
import 'package:to_do_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:to_do_app/models/DataFirebase.dart';
import 'package:to_do_app/models/SocialMediaLogin_RegistationHandler.dart';

class LoginScreen extends StatelessWidget {
  static String loginScreenId = 'loginScreen';
  @override
  Widget build(BuildContext context) {
    String _email;
    String _password;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Hero(
                  tag: 'StudentTag',
                  child: Container(
                    child: Text(
                      '👨‍🎓️',
                      style: TextStyle(fontSize: 80),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  onChanged: (value) {
                    _email = value;
                  },
                  textAlign: TextAlign.center,
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your email address'),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  onChanged: (value) {
                    _password = value;
                  },
                  textAlign: TextAlign.center,
                  obscureText: true,
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter you password'),
                ),
                SizedBox(
                  height: 20,
                ),
                CustomButton(
                    backgroundColor: Color(0xff8ADFCB),
                    onTap: () async {
                      try {
                        var logIn = await Provider.of<FirebaseController>(
                                context,
                                listen: false)
                            .getAuthInstance()
                            .signInWithEmailAndPassword(
                                email: _email, password: _password);
                        if (logIn != null) {
                          Navigator.pushNamed(
                              context, PageViewNavigation.pageViewNavigationID);
                        }
                      } on FirebaseAuthException catch (e) {
                        print(e);
                      }
                    },
                    name: 'Log in'),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Other log in option',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                GoogleButton(
                  type: 'Sign in with Google',
                  onTap: () async {
                    try {
                      var userCredentials = await SocialMediaHandler()
                          .signInWithGoogle(Provider.of<FirebaseController>(
                                  context,
                                  listen: false)
                              .getAuthInstance());
                      if (userCredentials != null) {
                        Navigator.popAndPushNamed(
                            context, PageViewNavigation.pageViewNavigationID);
                      }
                    } on FirebaseAuthException catch (e) {
                      print(e.code);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
