import 'package:flutter/material.dart';
import 'package:to_do_app/Screens/AddEventsScreen.dart';
import 'package:to_do_app/Widgets/EventsList.dart';
import 'package:to_do_app/Widgets/PageHeader.dart';
import 'package:to_do_app/Widgets/SideNavigationDrawer.dart';
import 'package:to_do_app/constants.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/models/DataEvents.dart';
import 'package:to_do_app/models/Event.dart';
import 'package:to_do_app/models/DataFirebase.dart';

class EventsScreen extends StatelessWidget {
  static String eventsScreenId = 'eventsScreen';
  Widget _buildEventsBottomSheet(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: AddEventsSheet(
          functionality: (Event eventToadd) {
            Provider.of<EventsController>(context, listen: false)
                .addEvent(eventToadd);
            Provider.of<FirebaseController>(context, listen: false)
                .addEvent(eventToadd);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerCustom(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: _buildEventsBottomSheet,
              isScrollControlled: true);
        },
        elevation: 3,
        child: Icon(
          Icons.add,
          color: Color(0xffEEEEEE),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PageHeader(
              pageName: 'Events',
            ),
            Expanded(
              child: Container(
                child: EventsList(),
                decoration: kRoundedContainerDecorator.copyWith(
                  color: Theme.of(context).primaryColorDark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
