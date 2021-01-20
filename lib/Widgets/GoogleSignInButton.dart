import 'package:flutter/material.dart';

class GoogleButton extends StatelessWidget {
  final Function onTap;
  GoogleButton({@required this.onTap});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: onTap,
      height: 60,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image(
                image: AssetImage('assets/googleLogo.png'),
                height: 35,
              ),
              Text(
                'Sign in with Google',
                style: TextStyle(
                  color: Color(0xff222831),
                  fontSize: 24,
                  fontFamily: 'Roboto',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
