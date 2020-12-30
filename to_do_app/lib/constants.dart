import 'package:flutter/material.dart';

const kRoundedContainerDecorator = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(30),
    topRight: Radius.circular(30),
  ),
);

const kTaskPreviewTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 18,
);
const textFieldDecoration = InputDecoration(
  hintText: '',
  focusColor: Color(0xff8ADFCB),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(20),
    ),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Color(0xff8ADFCB),
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(20),
    ),
  ),
  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
);
const kmainColor = Color(0xff8ADFCB);
