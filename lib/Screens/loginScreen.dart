import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/Screens/TaskScreen.dart';
import 'package:to_do_app/Screens/registationScreen.dart';
import 'package:to_do_app/Widgets/CustomButtonWidget.dart';
import 'package:to_do_app/Widgets/GoogleSignInButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:to_do_app/constants.dart';
import 'package:to_do_app/models/DataEvents.dart';
import 'package:to_do_app/models/DataFirebase.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:to_do_app/models/DataTask.dart';

class LoginScreen extends StatefulWidget {
  static String loginScreenId = 'loginScreen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email = '';
  String _password = '';
  bool _isLoading = false;
  int _attemptsCounter = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<FirebaseController>(
      builder: (context, firebase, child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: ModalProgressHUD(
            inAsyncCall: _isLoading,
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
                          _email = value;
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
                          _password = value;
                        },
                        obscureText: true,
                        decoration: kLogin_registerTextFields.copyWith(
                          hintText: 'Password',
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomButton(
                      backgroundColor: Color(0xffff6363),
                      onTap: () async {
                        setState(() {
                          _isLoading = true;
                          _attemptsCounter++;
                        });
                        if (_email == '' || _password == '') {
                          setState(() {
                            _isLoading = false;
                          });

                          await showOkAlertDialog(
                            context: context,
                            title: 'Empty email and password',
                            message:
                                'Please enter an email address and password before trying to log in',
                            okLabel: 'Continue',
                            barrierDismissible: false,
                          );
                        } else {
                          if (_attemptsCounter >= 3) {
                            await showOkAlertDialog(
                              context: context,
                              title: 'Password recovery',
                              message:
                                  'You\'ve tried many times a reset password email has been sent to your account',
                            );
                            try {
                              await firebase.auth
                                  .sendPasswordResetEmail(email: _email);
                              setState(() {
                                _isLoading = false;
                                _attemptsCounter = 0;
                              });
                            } on FirebaseAuthException catch (e) {
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
                            }
                          } else {
                            try {
                              var logIn = await firebase.auth
                                  .signInWithEmailAndPassword(
                                      email: _email, password: _password);
                              if (logIn != null) {
                                await Provider.of<TaskController>(context,
                                        listen: false)
                                    .fetchData();
                                await Provider.of<EventsController>(context,
                                        listen: false)
                                    .fetchEvents();
                                setState(() {
                                  _isLoading = false;
                                });
                                Navigator.popAndPushNamed(
                                    context, TasksScreen.taskScreenId);
                              }
                            } on FirebaseAuthException catch (e) {
                              setState(() {
                                _isLoading = false;
                              });
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
                        try {
                          var credentials = await firebase.signInWithGoogle();
                          if (credentials != null) {
                            Navigator.popAndPushNamed(
                                context, TasksScreen.taskScreenId);
                          }
                        } on FirebaseAuthException catch (e) {}
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
