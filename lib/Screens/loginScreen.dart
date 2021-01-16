import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/Screens/TaskScreen.dart';
import 'package:to_do_app/Widgets/CustomButtonWidget.dart';
import 'package:to_do_app/Widgets/GoogleSignInButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:to_do_app/constants.dart';
import 'package:to_do_app/models/DataEvents.dart';
import 'package:to_do_app/models/DataFirebase.dart';
import 'package:to_do_app/models/DataNotes.dart';
import 'package:to_do_app/models/DataTask.dart';
import 'package:to_do_app/models/SocialMediaLogin_RegistationHandler.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';

class LoginScreen extends StatelessWidget {
  static String loginScreenId = 'loginScreen';
  String _email;
  String _password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ModalProgressHUD(
        inAsyncCall: Provider.of<FirebaseController>(context).isLoading,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background.png'),
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
                      'Log in to your account',
                      style: TextStyle(
                        fontSize: 36,
                        fontFamily: 'Pacifico',
                        color: Color(0xff162447),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 70,
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
                    backgroundColor: Color(0xff222831),
                    onTap: () async {
                      try {
                        Provider.of<FirebaseController>(context, listen: false)
                            .toggleIsLoading();

                        var logIn = await Provider.of<FirebaseController>(
                                context,
                                listen: false)
                            .getAuthInstance()
                            .signInWithEmailAndPassword(
                                email: _email, password: _password);
                        if (logIn != null) {
                          await Provider.of<FirebaseController>(context,
                                  listen: false)
                              .fetchAllTasks(context);
                          Provider.of<EventsController>(context, listen: false)
                              .events = await Provider.of<FirebaseController>(
                                  context,
                                  listen: false)
                              .fetchEvents();
                          Provider.of<NotesController>(context, listen: false)
                              .setNote(
                            await Provider.of<FirebaseController>(context,
                                    listen: false)
                                .fetchNotes(),
                          );

                          Provider.of<FirebaseController>(context,
                                  listen: false)
                              .toggleIsLoading();
                          Navigator.popAndPushNamed(
                              context, TasksScreen.taskScreenId);
                        }
                      } on FirebaseAuthException catch (e) {
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
                        color: Color(0xff222831),
                      ),
                      Text(
                        'OR',
                        style:
                            TextStyle(fontSize: 18, color: Color(0xff222831)),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          left: 10,
                        ),
                        height: 2,
                        width: 100,
                        color: Color(0xff222831),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  GoogleButton(
                    onTap: () async {
                      try {
                        Provider.of<FirebaseController>(context, listen: false)
                            .toggleIsLoading();
                        var userCredentials = await SocialMediaHandler()
                            .signInWithGoogle(Provider.of<FirebaseController>(
                                    context,
                                    listen: false)
                                .getAuthInstance());
                        if (userCredentials != null) {
                          await Provider.of<FirebaseController>(context,
                                  listen: false)
                              .fetchAllTasks(context);
                          Provider.of<EventsController>(context, listen: false)
                              .events = await Provider.of<FirebaseController>(
                                  context,
                                  listen: false)
                              .fetchEvents();
                          Provider.of<FirebaseController>(context,
                                  listen: false)
                              .toggleIsLoading();

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
            ),
          ),
        ),
      ),
    );
  }
}
