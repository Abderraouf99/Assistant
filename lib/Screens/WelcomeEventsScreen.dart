import 'package:flutter/material.dart';

import 'loginScreen.dart';

class WelcomeEventScreeen extends StatelessWidget {
  final Function nextFunction;
  final Function backFuntion;
  WelcomeEventScreeen(
      {@required this.nextFunction, @required this.backFuntion});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Add your events ',
            style: TextStyle(
              color: Color(0xffEEEEEE),
              fontFamily: 'Pacifico',
              fontSize: 30,
            ),
          ),
          Text(
            'With assistant you can set up event easily and be reminded when the times comes',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xffEEEEEE),
              fontFamily: 'Ninito',
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Flexible(
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xffEEEEEE),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Image(
                image: AssetImage('assets/events.gif'),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: FlatButton(
                  child: Text('Back'),
                  onPressed: backFuntion,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xffff6363),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: FlatButton(
                  highlightColor: Colors.transparent,
                  child: Text(
                    'Next',
                    style: TextStyle(
                      color: Color(0xffEEEEEE),
                    ),
                  ),
                  onPressed: nextFunction,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
