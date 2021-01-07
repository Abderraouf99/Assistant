import 'package:flutter/material.dart';
import 'package:to_do_app/Screens/pageViewScreen.dart';
import 'package:to_do_app/constants.dart';

import 'package:to_do_app/models/DataFirebase.dart';
import 'package:to_do_app/Widgets/CustomButtonWidget.dart';
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
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Flexible(
                  child: Text(
                    'Create your account',
                    style: TextStyle(
                      fontSize: 36,
                      fontFamily: 'Pacifico',
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Opacity(
                  opacity: 0.7,
                  child: TextField(
                    onChanged: (value) {
                      _email = value;
                    },
                    decoration:
                        kLogin_registerTextFields.copyWith(hintText: 'Email'),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Opacity(
                  opacity: 0.7,
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    obscureText: true,
                    onChanged: (value) {
                      _password = value;
                    },
                    decoration: kLogin_registerTextFields.copyWith(
                        hintText: 'Password'),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                CustomButton(
                    backgroundColor: Color(0xff222831),
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
                          Provider.of<FirebaseController>(context,
                                  listen: false)
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
                    name: 'Register'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
