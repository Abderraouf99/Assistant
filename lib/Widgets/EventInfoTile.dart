import 'package:flutter/material.dart';
import 'package:to_do_app/constants.dart';

class EventInfoTile extends StatelessWidget {
  final String title;
  final String startTime;
  final String endTime;
  final bool status;
  EventInfoTile(
      {@required this.title,
      @required this.startTime,
      @required this.endTime,
      @required this.status});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: (status) ? Color(0xffffbd69) : Color(0xffff6363),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: kEventTextStyle.copyWith(
                    color: Color(0xffEEEEEE),
                  ),
                ),
                Icon(
                  (status) ? Icons.done : Icons.pending,
                  color: Color(0xffEEEEEE),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Starts at: $startTime ',
                  style: kEventTextStyle.copyWith(
                    color: Color(0xffEEEEEE),
                  ),
                ),
                Text(
                  'Ends at: $endTime ',
                  style: kEventTextStyle.copyWith(
                    color: Color(0xffEEEEEE),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DayTile extends StatelessWidget {
  final String month;
  final String day;
  DayTile({@required this.month, @required this.day});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            month,
            style: kEventTextStyle,
          ),
          Text(
            day,
            style: kEventTextStyle,
          ),
        ],
      ),
    );
  }
}
