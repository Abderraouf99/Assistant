import 'package:flutter/material.dart';

const kRoundedContainerDecorator = BoxDecoration(
  color: Color(0xffEEEEEE),
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(5),
    topRight: Radius.circular(5),
  ),
);

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
      return Color(0xffffbd69);
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
