import 'package:flutter/material.dart';
import 'package:to_do_app/constants.dart';
import 'package:to_do_app/models/SocialMediaLogin_RegistationHandler.dart';
import 'TaskScreen.dart';
import 'package:to_do_app/Widgets/CustomButtonWidget.dart';
import 'package:to_do_app/Widgets/GoogleSignInButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';

class RegistrationScreen extends StatelessWidget {
  static String registrationScreenID = 'RegistationScreen';
  final _auth = FirebaseAuth.instance;

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
                  decoration: textFieldDecoration.copyWith(
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
                  decoration: textFieldDecoration.copyWith(
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
                      await _auth.createUserWithEmailAndPassword(
                          email: _email, password: _password);
                      User currentUser = _auth.currentUser;

                      if (!currentUser.emailVerified) {
                        await currentUser.sendEmailVerification();
                      }
                      await showOkAlertDialog(
                        context: context,
                        title: 'Check your email',
                        message:
                            'Hurry up log into your email and verify your account 🏃️ ',
                        okLabel: 'Continue',
                        barrierDismissible: false,
                      );
                      if (currentUser.emailVerified) {
                        Navigator.popAndPushNamed(
                            context, TasksScreen.taskScreenId);
                      } else {
                        showModalActionSheet(
                          context: context,
                          title: 'Error',
                          message: 'Failed to verify account 😥️',
                        );
                        await currentUser.delete();
                      }
                    } on FirebaseAuthException catch (e) {
                      print(e.code);
                      if (e.code == 'email-already-in-use') {
                        Navigator.popAndPushNamed(
                            context, TasksScreen.taskScreenId);
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
                  type: 'Sign up with Google',
                  onTap: () async {
                    try {
                      var userCredentials =
                          await SocialMediaHandler().signInWithGoogle(_auth);
                      if (userCredentials != null) {
                        Navigator.popAndPushNamed(
                            context, TasksScreen.taskScreenId);
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
