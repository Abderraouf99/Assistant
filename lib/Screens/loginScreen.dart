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
import 'package:to_do_app/models/DataNotes.dart';
import 'package:to_do_app/models/DataTask.dart';

class LoginScreen extends StatefulWidget {
  static String loginScreenId = 'loginScreen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email;
  String _password;
  bool _isLoading = false;
  bool _showHeader = true;
  String _loginErrorMessage;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Consumer<FirebaseController>(
      builder: (context, firebase, child) {
        return Scaffold(
          backgroundColor: Color(0xff222831),
          resizeToAvoidBottomInset: false,
          body: ModalProgressHUD(
            inAsyncCall: _isLoading,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedContainer(
                      duration: Duration(milliseconds: 100),
                      child: (_showHeader)
                          ? Column(
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
                                  height: 20,
                                ),
                                InkWell(
                                  child: Text(
                                    'Don\'t have an account yet ? Register now',
                                    style: TextStyle(
                                      color: Color(0xffEEEEEE),
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context,
                                        RegistrationScreen
                                            .registrationScreenID);
                                  },
                                ),
                              ],
                            )
                          : Container(
                              child: InkWell(
                                onTap: () {
                                  FocusScopeNode currentFocus =
                                      FocusScope.of(context);
                                  if (!currentFocus.hasPrimaryFocus) {
                                    currentFocus.unfocus();
                                  }
                                  setState(() {
                                    _email = null;
                                    _showHeader = true;
                                  });
                                },
                                child: Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Opacity(
                            opacity: 0.7,
                            child: TextFormField(
                              onTap: () {
                                setState(() {
                                  _showHeader = false;
                                });
                              },
                              validator: (value) {
                                if (_loginErrorMessage == kInvalidEmail) {
                                  return kInvalidEmail;
                                } else if (_loginErrorMessage == kNullParam) {
                                  return 'Enter an email address before logging in';
                                } else if (_loginErrorMessage ==
                                    kUserNotFound) {
                                  return 'No account is linked to this email address';
                                }
                                return null;
                              },
                              decoration: kLogin_registerTextFields.copyWith(
                                hintText: 'Email',
                                errorStyle: TextStyle(color: Colors.red),
                              ),
                              style: TextStyle(
                                color: Color(0xff162447),
                              ),
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  _email = value;
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Opacity(
                            opacity: 0.7,
                            child: TextFormField(
                              onTap: () {
                                setState(() {
                                  _showHeader = false;
                                });
                              },
                              validator: (value) {
                                if (_loginErrorMessage == kWrongPassword) {
                                  return 'Wrong password';
                                } else if (_loginErrorMessage == kNullParam) {
                                  return 'Enter a password before logging in';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  _password = value;
                                }
                              },
                              obscureText: true,
                              decoration: kLogin_registerTextFields.copyWith(
                                hintText: 'Password',
                              ),
                              style: TextStyle(
                                color: Color(0xff162447),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    (_email != null)
                        ? FlatButton(
                            child: Text(
                              'Forgot password ? click here',
                              style: TextStyle(
                                color: Color(0xffEEEEEE),
                              ),
                            ),
                            onPressed: () async {
                              String recoverResult =
                                  await firebase.recoverPassword(_email);
                              if (recoverResult == kResetSuccess) {
                                await showAlertDialog(
                                  context: context,
                                  title: 'Recovery email sent',
                                  message:
                                      'Follow the intructions on the email and recover your account',
                                );
                              } else {
                                await showAlertDialog(
                                  context: context,
                                  title: 'Recovery email error',
                                  message:
                                      'You don\'t have an account with this email',
                                );
                              }
                            },
                          )
                        : Container(),
                    SizedBox(
                      height: 20,
                    ),
                    CustomButton(
                      backgroundColor: Color(0xffff6363),
                      onTap: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        String loginMessage = await firebase.logIn(
                            email: _email, password: _password);
                        setState(() {
                          _isLoading = false;
                          _loginErrorMessage = loginMessage;
                        });

                        if (_formKey.currentState.validate() &&
                            loginMessage == kSuccessMessage) {
                          setState(() {
                            _isLoading = true;
                          });
                          await Provider.of<TaskController>(context,
                                  listen: false)
                              .fetchData();

                          await Provider.of<EventsController>(context,
                                  listen: false)
                              .fetchEvents();
                          await Provider.of<NotesController>(context,
                                  listen: false)
                              .fetchNotes();
                          setState(() {
                            _isLoading = false;
                          });
                          Navigator.pushNamedAndRemoveUntil(
                              context,
                              TasksScreen.taskScreenId,
                              (Route<dynamic> route) => false);
                        }
                      },
                      name: 'Login',
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    (_showHeader)
                        ? Row(
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
                          )
                        : Container(),
                    SizedBox(
                      height: 15,
                    ),
                    (_showHeader)
                        ? GoogleButton(
                            onTap: () async {
                              setState(() {
                                _isLoading = true;
                              });
                              try {
                                var credentials =
                                    await firebase.signInWithGoogle();
                                await Provider.of<TaskController>(context,
                                        listen: false)
                                    .fetchData();

                                await Provider.of<EventsController>(context,
                                        listen: false)
                                    .fetchEvents();
                                await Provider.of<NotesController>(context,
                                        listen: false)
                                    .fetchNotes();
                                if (credentials != null) {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      TasksScreen.taskScreenId,
                                      (Route<dynamic> route) => false);
                                }
                              } on FirebaseAuthException catch (e) {
                                print(e);
                              }
                            },
                          )
                        : Container(),
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
