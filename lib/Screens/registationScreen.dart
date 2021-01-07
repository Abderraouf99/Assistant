import 'package:flutter/material.dart';
import 'package:to_do_app/Screens/pageViewScreen.dart';
import 'package:to_do_app/constants.dart';
import 'package:to_do_app/models/DataFirebase.dart';
import 'package:to_do_app/models/SocialMediaLogin_RegistationHandler.dart';
import 'package:to_do_app/Widgets/CustomButtonWidget.dart';
import 'package:to_do_app/Widgets/GoogleSignInButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';

import 'package:provider/provider.dart';

class RegistrationScreen extends StatelessWidget {
  static String registrationScreenID = 'RegistationScreen';

  @override
  Widget build(BuildContext context) {
    String _email;
    String _password;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(20),
          children: [
            Column(
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
                  keyboardType: TextInputType.emailAddress,
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
                  name: 'Register',
                  backgroundColor: Color(0xff6BAF9F),
                  onTap: () async {
                    try {
                      UserCredential currentUser =
                          await Provider.of<FirebaseController>(context,
                                  listen: false)
                              .getAuthInstance()
                              .createUserWithEmailAndPassword(
                                  email: _email, password: _password);

                      if (!currentUser.user.emailVerified) {
                        await currentUser.user.sendEmailVerification();
                      }
                      await showOkAlertDialog(
                        context: context,
                        title: 'Check your email',
                        message:
                            'Hurry up log into your email and verify your account 🏃️ ',
                        okLabel: 'Continue',
                        barrierDismissible: false,
                      );
                      await currentUser.user.reload();

                      if (Provider.of<FirebaseController>(context,
                              listen: false)
                          .getAuthInstance()
                          .currentUser
                          .emailVerified) {
                        Provider.of<FirebaseController>(context, listen: false)
                            .createNewUserDocument();

                        Navigator.popAndPushNamed(
                            context, PageViewNavigation.pageViewNavigationID);
                      } else {
                        showModalActionSheet(
                          context: context,
                          title: 'Error',
                          message: 'Failed to verify account 😥️',
                        );
                        await currentUser.user.delete();
                      }
                    } on FirebaseAuthException catch (e) {
                      print(e.code);
                      if (e.code == 'email-already-in-use') {
                        Navigator.popAndPushNamed(
                            context, PageViewNavigation.pageViewNavigationID);
                      }
                    }
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Other registration option',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                GoogleButton(
                  onTap: () async {
                    try {
                      var userCredentials = await SocialMediaHandler()
                          .signInWithGoogle(Provider.of<FirebaseController>(
                                  context,
                                  listen: false)
                              .getAuthInstance());
                      if (userCredentials != null) {
                        Provider.of<FirebaseController>(context, listen: false)
                            .createNewUserDocument();
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
          ],
        ),
      ),
    );
  }
}
