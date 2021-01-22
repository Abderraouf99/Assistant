import 'package:flutter/material.dart';

class CustomStartEndWidget extends StatelessWidget {
  final Function onPressed;
  final String name;
  final String date;
  CustomStartEndWidget(
      {@required this.name, @required this.onPressed, @required this.date});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(name),
      trailing: Text(date),
      onTap: onPressed,
    );
  }
}
