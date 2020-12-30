import 'package:flutter/material.dart';

const kRoundedContainerDecorator = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(10),
    topRight: Radius.circular(10),
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

const eventTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 15,
  fontWeight: FontWeight.bold,
);
