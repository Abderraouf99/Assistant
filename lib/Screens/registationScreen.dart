import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:to_do_app/Screens/TaskScreen.dart';
import 'package:to_do_app/Screens/loginScreen.dart';
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
    return Consumer<FirebaseController>(
      builder: (context, firebase, child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: ModalProgressHUD(
            inAsyncCall: firebase.isLoading,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Join us',
                      style: TextStyle(
                        fontSize: 45,
                        color: Color(0xffEEEEEE),
                        fontFamily: 'Nunito',
                      ),
                    ),
                    Text(
                      'Register now',
                      style: TextStyle(
                        fontSize: 45,
                        color: Color(0xffEEEEEE),
                        fontFamily: 'Nunito',
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Opacity(
                      opacity: 0.7,
                      child: TextField(
                        style: TextStyle(
                          color: Color(0xff162447),
                        ),
                        onChanged: (value) {
                          firebase.setEmail = value;
                        },
                        decoration: kLogin_registerTextFields.copyWith(
                            hintText: 'Email'),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Opacity(
                      opacity: 0.7,
                      child: TextField(
                        style: TextStyle(
                          color: Color(0xff162447),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        obscureText: true,
                        onChanged: (value) {
                          firebase.setPassword = value;
                        },
                        decoration: kLogin_registerTextFields.copyWith(
                            hintText: 'Password'),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    CustomButton(
                        backgroundColor: Color(0xffff6363),
                        onTap: () async {
                          try {
                            firebase.toggleIsLoading();
                            UserCredential currentUser = await firebase
                                .getAuthInstance()
                                .createUserWithEmailAndPassword(
                                    email: firebase.email,
                                    password: firebase.password);
                            firebase.toggleIsLoading();

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

                            if (firebase
                                .getAuthInstance()
                                .currentUser
                                .emailVerified) {
                              firebase.createNewUserDocument();

                              Navigator.popAndPushNamed(
                                  context, TasksScreen.taskScreenId);
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
                              await showAlertDialog(
                                context: context,
                                title: 'You already have an account',
                                message:
                                    'You are going to be directed to the login screen',
                              );
                              Navigator.popAndPushNamed(
                                  context, LoginScreen.loginScreenId);
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
      },
    );
  }
}
