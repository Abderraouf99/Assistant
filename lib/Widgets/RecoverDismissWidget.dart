import 'package:flutter/material.dart';
class RecoverDismissWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Icon(
        Icons.undo,
        color: Color(0xffEEEEEE),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.green,
      ),
    );
  }
}