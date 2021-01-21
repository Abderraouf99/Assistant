import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/Screens/AddEventsScreen.dart';
import 'package:to_do_app/Widgets/EventsLists/EventsList.dart';
import 'package:to_do_app/Widgets/PageHeader.dart';
import 'package:to_do_app/constants.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:to_do_app/models/DataEvents.dart';
import 'package:to_do_app/models/DataFirebase.dart';
import 'package:to_do_app/models/Event.dart';
import 'package:to_do_app/Widgets/SideNavigationDrawer.dart';
class CalendarView extends StatefulWidget {
  static String id = "CalendarView";

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  CalendarController _calendarController;
  DateTime _currentTime = DateTime.now();
  @override
  void initState() {
    super.initState();
    _calendarController = new CalendarController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  Widget _buildEventsBottomSheet(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: AddEventsSheet(
          selectedTime: _currentTime,
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
      drawer: DrawerCustom() ,
      resizeToAvoidBottomInset: false,
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
                decoration: kRoundedContainerDecorator.copyWith(
                  color: Theme.of(context).primaryColorDark,
                ),
                child: Column(
                  children: [
                    TableCalendar(
                      calendarStyle: CalendarStyle(
                        highlightToday: true,
                        selectedColor: Theme.of(context).primaryColor,
                        todayColor: Colors.grey[500],
                      ),
                      calendarController: _calendarController,
                      onDaySelected: (a, b, c) {
                        setState(
                          () {
                            _currentTime = a;
                          },
                        );
                      },
                      initialCalendarFormat: CalendarFormat.twoWeeks,
                    ),
                    Expanded(
                      child: Container(
                        child: EventsList(
                          selectedDate: _currentTime,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
