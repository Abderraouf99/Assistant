import 'package:flutter/material.dart';

const String kSuccessMessage = 'Loged in';
const String kUserNotFound = 'Please register before using the application';
const String kWrongPassword = 'Please make sure you type the right password';
const String kInvalidEmail = 'Please make sure your email address is valid';
const String kNullParam = 'Please enter both an email address and a password';
const String kResetSuccess = 'reset password success';
const String kResetEmailNull = 'reset password error';
const String kAccountExist = 'account-exists';
const String kSuccessRegistration = 'registration-success';
const kRoundedContainerDecorator = BoxDecoration(
  color: Color(0xffEEEEEE),
  borderRadius: BorderRadius.only(),
);
const List<Tab> myTabs = [
  Tab(
    icon: Icon(Icons.list),
    text: 'Tasks',
  ),
  Tab(
    icon: Icon(Icons.event),
    text: 'Events',
  ),
  Tab(
    icon: Icon(Icons.note),
    text: 'Notes',
  ),
];
const kTaskPreviewTextStyle = TextStyle(
  color: Color(0xffEEEEEE),
  fontSize: 18,
);
const kTextFieldDecoration = InputDecoration(
  hintText: '',
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(10),
    ),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.grey,
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(10),
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(),
    borderRadius: BorderRadius.all(
      Radius.circular(10),
    ),
  ),
  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
);
const kmainColor = Color(0xff00ADB5);

const kEventTextStyle = TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.bold,
);

const kLogin_registerTextFields = InputDecoration(
  filled: true,
  fillColor: Color(0xffEEEEEE),
  hintText: '',
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
);

Color determineColor(Brightness brightness, bool state) {
  if (brightness == Brightness.dark) {
    if (state) {
      return Color(0xff51c2d5);
    } else {
      return Color(0xffff6363);
    }
  } else {
    if (state) {
      return Color(0xff30475e);
    } else {
      return Color(0xfff05454);
    }
  }
}
