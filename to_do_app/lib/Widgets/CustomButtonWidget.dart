import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Color backgroundColor;
  final Function onTap;
  final String name;
  CustomButton(
      {@required this.backgroundColor,
      @required this.onTap,
      @required this.name});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: InkWell(
        highlightColor: backgroundColor,
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Center(
            child: Text(
              name,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
            color: backgroundColor,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
