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
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatelessWidget {
  static String loginScreenId = 'loginScreen';
  @override
  Widget build(BuildContext context) {
    String _email;
    String _password;
    bool loading =
        Provider.of<FirebaseController>(context, listen: false).loading;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ModalProgressHUD(
        color: Color(0xff222831),
        inAsyncCall: loading,
        child: Container(
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
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 70,
                  ),
                  Opacity(
                    opacity: 0.7,
                    child: TextField(
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
                            .toggleLoading();
                        var logIn = await Provider.of<FirebaseController>(
                                context,
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
                          Provider.of<FirebaseController>(context,
                                  listen: false)
                              .toggleLoading();
                          Navigator.pushNamed(
                              context, PageViewNavigation.pageViewNavigationID);
                        }
                      } on FirebaseAuthException catch (e) {
                        print(e);
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
                            .toggleLoading();
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
                          Provider.of<FirebaseController>(context,
                                  listen: false)
                              .toggleLoading();
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
      ),
    );
  }
}
