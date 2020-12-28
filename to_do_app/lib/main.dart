import 'package:flutter/material.dart';
import 'package:to_do_app/Screens/TaskScreen.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/Screens/WelcomeScreen.dart';
import 'package:to_do_app/Screens/loginScreen.dart';
import 'package:to_do_app/Screens/registationScreen.dart';
import 'package:to_do_app/models/Data.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Data(),
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: 'Roboto',
        ),
        home: TasksScreen(),
        initialRoute: WelcomeScreen.welcomeScreenID,
        routes: {
          WelcomeScreen.welcomeScreenID: (context) => WelcomeScreen(),
          LoginScreen.loginScreenId: (context) => LoginScreen(),
          RegistrationScreen.registrationScreenID: (context) =>
              RegistrationScreen(),
          TasksScreen.taskScreenId: (context) => TasksScreen(),
        },
      ),
    );
  }
}
