import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:to_do_app/Screens/AddEventsTaskScreen.dart';
import 'package:to_do_app/Widgets/EventsList.dart';
import 'package:to_do_app/constants.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/models/DataEvents.dart';
import 'package:to_do_app/models/DataTask.dart';

class EventsScreen extends StatelessWidget {
  static String eventsScreenId = 'eventsScreen';
  Widget buildEventsBottomSheet(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: AddEventsSheet(),
      ),
    );
  }

  int calculateProgressBarValue(BuildContext context) {
    int total = Provider.of<EventsController>(context).events.length;
    if (total == 0) {
      return 0;
    }
    int completed =
        Provider.of<EventsController>(context).findNumberOfCompletedEvents();
    double ratio = (completed.toDouble() / total.toDouble()) * 100;
    return ratio.toInt();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: buildEventsBottomSheet,
              isScrollControlled: true);
        },
        backgroundColor: Color(0xff8ADFCB),
        elevation: 3,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      backgroundColor: kmainColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding:
                  EdgeInsets.only(left: 30, top: 25, bottom: 30, right: 30),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 30,
                    child: Icon(
                      Icons.schedule,
                      color: kmainColor,
                      size: 30,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Events',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '${Provider.of<EventsController>(context).events.length} Events',
                        style: kTaskPreviewTextStyle,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        '${Provider.of<EventsController>(context).findNumberOfCompletedEvents()} Events completed',
                        style: kTaskPreviewTextStyle,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FAProgressBar(
                    currentValue: calculateProgressBarValue(context),
                    progressColor: Color(0xffA2EEDC),
                    displayText: '% ',
                    displayTextStyle:
                        TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: EventsList(),
                decoration: kRoundedContainerDecorator,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
