import 'package:flutter/material.dart';

class PageHeader extends StatelessWidget {
  final String pageName;
  PageHeader({@required this.pageName});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 30, top: 25, bottom: 30, right: 30),
      child: Text(
        pageName,
        style: TextStyle(
          fontFamily: 'Pacifico',
          color: Color(0xffEEEEEE),
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
