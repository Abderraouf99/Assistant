import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/Screens/pageViewScreen.dart';
import 'package:to_do_app/Widgets/CustomButtonWidget.dart';
import 'package:to_do_app/Widgets/GoogleSignInButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:to_do_app/models/DataEvents.dart';
import 'package:to_do_app/models/DataFirebase.dart';
import 'package:to_do_app/models/DataTask.dart';
import 'package:to_do_app/models/SocialMediaLogin_RegistationHandler.dart';

class LoginScreen extends StatelessWidget {
  static String loginScreenId = 'loginScreen';
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
                    'Welcome to your student companion',
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
                  opacity: 0.4,
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xffEEEEEE),
                      hintText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Opacity(
                  opacity: 0.4,
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xffEEEEEE),
                      hintText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                CustomButton(
                  backgroundColor: Color(0xff222831),
                  onTap: () async {
                    //TODO : add the functionnality of the login here
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
