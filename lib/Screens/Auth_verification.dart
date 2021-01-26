import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/Screens/TaskScreen.dart';
import 'package:to_do_app/Screens/WelcomeScreenMenu.dart';

class Authentificate extends StatelessWidget {
  static String id = '/auth_verification';
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    if (firebaseUser != null) {
      return TasksScreen();
    } else {
      return WelcomeMenu();
    }
  }
}
