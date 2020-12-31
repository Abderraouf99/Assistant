import 'package:flutter/material.dart';
import 'package:to_do_app/Screens/EventsScreen.dart';
import 'package:to_do_app/Screens/TaskScreen.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/Screens/WelcomeScreen.dart';
import 'package:to_do_app/Screens/loginScreen.dart';
import 'package:to_do_app/Screens/registationScreen.dart';
import 'package:to_do_app/constants.dart';
import 'package:to_do_app/models/DataEvents.dart';
import 'package:to_do_app/models/DataFirebase.dart';
import 'package:to_do_app/models/DataTask.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ControllerTask(),
        ),
        ChangeNotifierProvider(
          create: (context) => EventsController(),
        ),
        ChangeNotifierProvider(
          create: (context) => FirebaseController(),
        )
      ],
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.light().copyWith(
            primary: kmainColor,
          ),
          fontFamily: 'Roboto',
          highlightColor: kmainColor,
          timePickerTheme: TimePickerThemeData(
            dialHandColor: kmainColor,
            hourMinuteTextColor: kmainColor,
            inputDecorationTheme: InputDecorationTheme(),
          ),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(kmainColor),
              overlayColor: MaterialStateProperty.all<Color>(Colors.grey[200]),
            ),
          ),
        ),
        initialRoute: WelcomeScreen.welcomeScreenID,
        routes: {
          WelcomeScreen.welcomeScreenID: (context) => WelcomeScreen(),
          LoginScreen.loginScreenId: (context) => LoginScreen(),
          RegistrationScreen.registrationScreenID: (context) =>
              RegistrationScreen(),
          TasksScreen.taskScreenId: (context) => TasksScreen(),
          EventsScreen.eventsScreenId: (context) => EventsScreen()
        },
      ),
    );
  }
}
