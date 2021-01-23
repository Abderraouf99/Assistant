import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../constants.dart';

class FirebaseController extends ChangeNotifier {
  var _auth = FirebaseAuth.instance;
  final _firestoreReference = FirebaseFirestore.instance.collection('users');
  FirebaseController();
  FirebaseController.instance({FirebaseAuth auth}) {
    _auth = auth;
  }
  FirebaseAuth get auth => _auth;
  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return await _auth.signInWithCredential(credential);
  }

  Future<void> createNewUserDocument() async {
    await _firestoreReference.doc('${_auth.currentUser.email}').set(
      {'id': '${_auth.currentUser.email}'},
    );
  }

  Future<String> logIn({String email, String password}) async {
    String message = '';
    try {
      if (email == null || password == null) {
        throw FirebaseAuthException(
          message: 'email-or-password-is-null',
          code: 'null-param',
        );
      } else {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        message = kSuccessMessage;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        message = kUserNotFound;
      } else if (e.code == 'wrong-password') {
        message = kWrongPassword;
      } else if (e.code == 'invalid-email') {
        message = kInvalidEmail;
      } else if (e.code == 'null-param') {
        message = kNullParam;
      }
    }
    return message;
  }

  Future<String> recoverPassword(String email) async {
    String message;
    try {
      if (email == null) {
        throw FirebaseAuthException(
            message: 'Enter a valid email address',
            code: 'recovery-email-address-null');
      } else {
        await _auth.sendPasswordResetEmail(email: email);
        message = kResetSuccess;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'recovery-email-address-null') {
        message = kResetEmailNull;
      } else {
        print(e.code);
      }
    }
    return message;
  }

  Future<String> registerWithEmail(String email, String password) async {
    String message;
    try {
      if (email == null || password == null) {
        throw FirebaseAuthException(message: 'null-credentials');
      } else {
        UserCredential credentials = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await credentials.user.sendEmailVerification();
        message = kSuccessRegistration;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        message = kAccountExist;
      } else {
        message = kNullParam;
      }
    }

    return message;
  }
}
