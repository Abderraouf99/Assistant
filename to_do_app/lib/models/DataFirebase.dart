import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseController extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;

  FirebaseAuth getAuthInstance() {
    return _auth;
  }
}
