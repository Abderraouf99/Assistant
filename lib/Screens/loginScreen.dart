import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/Screens/pageViewScreen.dart';
import 'package:to_do_app/Widgets/CustomButtonWidget.dart';
import 'package:to_do_app/Widgets/GoogleSignInButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:to_do_app/constants.dart';
import 'package:to_do_app/models/DataEvents.dart';
import 'package:to_do_app/models/DataFirebase.dart';
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
                    'Log in to your account',
                    style: TextStyle(
                      fontSize: 36,
                      fontFamily: 'Pacifico',
                      color: Theme.of(context).primaryColorDark,
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
                      color: Theme.of(context).primaryColorDark,
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
                      color: Theme.of(context).primaryColorDark,
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
                      var logIn = await Provider.of<FirebaseController>(context,
                              listen: false)
                          .getAuthInstance()
                          .signInWithEmailAndPassword(
                              email: _email, password: _password);
                      if (logIn != null) {
                        Provider.of<ControllerTask>(context, listen: false)
                            .setTasks(
                          await Provider.of<FirebaseController>(context,
                                  listen: false)
                              .fetchTasks(),
                        );
                        Provider.of<EventsController>(context, listen: false)
                            .events = await Provider.of<FirebaseController>(
                                context,
                                listen: false)
                            .fetchEvents();

                        Navigator.pushNamed(
                            context, PageViewNavigation.pageViewNavigationID);
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
                              'Please make sure your password is at least 6 characters long',
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
                      style: TextStyle(fontSize: 18, color: Color(0xff222831)),
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
                      var userCredentials = await SocialMediaHandler()
                          .signInWithGoogle(Provider.of<FirebaseController>(
                                  context,
                                  listen: false)
                              .getAuthInstance());
                      if (userCredentials != null) {
                        Provider.of<ControllerTask>(context, listen: false)
                            .setTasks(
                          await Provider.of<FirebaseController>(context,
                                  listen: false)
                              .fetchTasks(),
                        );
                        Provider.of<EventsController>(context, listen: false)
                            .events = await Provider.of<FirebaseController>(
                                context,
                                listen: false)
                            .fetchEvents();

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
