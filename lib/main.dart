import 'package:flutter/material.dart';
import 'package:to_do_app/Screens/EventsScreen.dart';
import 'package:to_do_app/Screens/TaskScreen.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/Screens/WelcomeScreenUpdated.dart';
import 'package:to_do_app/Screens/loginScreen.dart';
import 'package:to_do_app/Screens/pageViewScreen.dart';
import 'package:to_do_app/Screens/registationScreen.dart';
import 'package:to_do_app/models/DataEvents.dart';
import 'package:to_do_app/models/DataFirebase.dart';
import 'package:to_do_app/models/DataTask.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

//TODO: refactor code
//TODO: Add a bin functionnality
//TODO: Add an archive functionnality
final FlutterLocalNotificationsPlugin localNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var initializeSettingAndroid = AndroidInitializationSettings('appicon');
  var initSettings = InitializationSettings(android: initializeSettingAndroid);
  await localNotificationsPlugin.initialize(initSettings);

  await Firebase.initializeApp();
  runApp(
    MyApp(),
  );
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
        ),
      ],
      child: MaterialApp(
        themeMode: ThemeMode.system,
        darkTheme: ThemeData(
          colorScheme: ColorScheme.dark().copyWith(
            primary: Color(0xffffbd69),
          ),
          brightness: Brightness.dark,
          highlightColor: Colors.grey[500],
          hintColor: Color(0xff202040),
          primaryColorDark: Color(0xff162447),
          primaryColor: Color(0xffffbd69),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(
                Color(0xffff6363),
              ),
            ),
          ),
          accentColor: Color(0xffEEEEEE),
          scaffoldBackgroundColor: Color(0xff1F4068),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Color(0xff1F4068),
          ),
          popupMenuTheme: PopupMenuThemeData(
            color: Color(0xff29335F),
            elevation: 3,
          ),
        ),
        theme: ThemeData(
          scaffoldBackgroundColor: Color(0xff222831),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Color(0xff30475e),
          ),
          colorScheme: ColorScheme.light().copyWith(
            primary: Color(0xff222831),
          ),
          primaryColor: Color(0xff30475e),
          primaryColorDark: Color(0xffdddddd),
          fontFamily: 'Roboto',
          highlightColor: Color(0xff222831),
          timePickerTheme: TimePickerThemeData(
            dialHandColor: Color(0xff222831),
            hourMinuteTextColor: Color(0xff222831),
            inputDecorationTheme: InputDecorationTheme(),
          ),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(
                Color(0xff222831),
              ),
              overlayColor: MaterialStateProperty.all<Color>(Colors.grey[200]),
            ),
          ),
        ),
        initialRoute: WelcomeScreenNew.welcomeScreenID,
        routes: {
          WelcomeScreenNew.welcomeScreenID: (context) => WelcomeScreenNew(),
          LoginScreen.loginScreenId: (context) => LoginScreen(),
          RegistrationScreen.registrationScreenID: (context) =>
              RegistrationScreen(),
          TasksScreen.taskScreenId: (context) => TasksScreen(),
          EventsScreen.eventsScreenId: (context) => EventsScreen(),
          PageViewNavigation.pageViewNavigationID: (context) =>
              PageViewNavigation(),
        },
      ),
    );
  }
}
