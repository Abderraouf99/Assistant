import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/Screens/TaskScreen.dart';
import 'package:to_do_app/Screens/registationScreen.dart';
import 'package:to_do_app/Widgets/CustomButtonWidget.dart';
import 'package:to_do_app/Widgets/GoogleSignInButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:to_do_app/constants.dart';
import 'package:to_do_app/models/DataFirebase.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';

class LoginScreen extends StatelessWidget {
  static String loginScreenId = 'loginScreen';

  @override
  Widget build(BuildContext context) {
    return Consumer<FirebaseController>(
      builder: (context, firebase, child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: ModalProgressHUD(
            inAsyncCall: Provider.of<FirebaseController>(context).isLoading,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
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
                      'Login now',
                      style: TextStyle(
                        fontSize: 45,
                        color: Color(0xffEEEEEE),
                        fontFamily: 'Nunito',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FlatButton(
                      child: Text(
                        'Don\'t have an account yet ? Register now',
                        style: TextStyle(
                          color: Color(0xffEEEEEE),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(
                            context, RegistrationScreen.registrationScreenID);
                      },
                    ),
                    SizedBox(
                      height: 10,
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
                          hintText: 'Email',
                        ),
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
                        onChanged: (value) {
                          firebase.setPassword = value;
                        },
                        obscureText: true,
                        decoration: kLogin_registerTextFields.copyWith(
                          hintText: 'Password',
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FlatButton(
                      child: Text(
                        'Forgot your password? click here to recover',
                        style: TextStyle(
                          color: Color(0xffEEEEEE),
                        ),
                      ),
                      onPressed: () async {
                        List<String> email;
                        if (firebase.email == null) {
                          email = await showTextInputDialog(
                            context: context,
                            textFields: [
                              DialogTextField(
                                hintText: 'Enter email adress',
                              ),
                            ],
                          );
                          if (email.isNotEmpty) {
                            await showOkAlertDialog(
                              context: context,
                              title: 'Check your email',
                              message:
                                  'A password recovering email has been sent to your email account',
                              okLabel: 'Continue',
                              barrierDismissible: false,
                            );
                            await firebase
                                .getAuthInstance()
                                .sendPasswordResetEmail(
                                  email: email.first,
                                );
                          }
                        }
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomButton(
                      backgroundColor: Color(0xffff6363),
                      onTap: () async {
                        try {
                          firebase.toggleIsLoading();
                          var logIn = firebase
                              .getAuthInstance()
                              .signInWithEmailAndPassword(
                                  email: firebase.email,
                                  password: firebase.password);
                          if (logIn != null) {
                            await firebase.fetchData(context);
                            firebase.toggleIsLoading();
                            Navigator.popAndPushNamed(
                                context, TasksScreen.taskScreenId);
                          }
                        } on FirebaseAuthException catch (e) {
                          firebase.toggleIsLoading();
                          print(e.code);
                          if (e.code == 'user-not-found') {
                            await showOkAlertDialog(
                              context: context,
                              title: 'This account doesn\'t exist ',
                              message:
                                  'Please register before using the application',
                              okLabel: 'Continue',
                              barrierDismissible: false,
                            );
                          }
                          if (e.code == 'wrong-password') {
                            await showOkAlertDialog(
                              context: context,
                              title: 'Wrong password',
                              message:
                                  'Please make sure you type the right password',
                              okLabel: 'Continue',
                              barrierDismissible: false,
                            );
                          }
                          if (e.code == 'invalid-email') {
                            await showOkAlertDialog(
                              context: context,
                              title: 'Invalid email address',
                              message:
                                  'Please make sure your email address is valid',
                              okLabel: 'Continue',
                              barrierDismissible: false,
                            );
                          }
                        }
                      },
                      name: 'Login',
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            right: 10,
                          ),
                          height: 2,
                          width: 100,
                          color: Color(0xffEEEEEE),
                        ),
                        Text(
                          'OR',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xffEEEEEE),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            left: 10,
                          ),
                          height: 2,
                          width: 100,
                          color: Color(0xffEEEEEE),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    GoogleButton(
                      onTap: () async {
                        firebase.signInWithGoogle().then((result) {
                          if (result != null) {
                            Navigator.popAndPushNamed(
                                context, TasksScreen.taskScreenId);
                          } else {
                            Navigator.popAndPushNamed(
                                context, LoginScreen.loginScreenId);
                          }
                        });
                      },
                    ),
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
