import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:to_do_app/models/Event.dart';
import 'package:timezone/timezone.dart' as tz;
import '../main.dart';

/// Constants used for the firebase cloud firestore
const String kEvent = 'activeEvents';
const String kArchived = 'archivedEvents';
const String kDeleted = 'deletedEvents';
const String kEventTitle = 'eventTitle';
const String kEventStartDate = 'eventStartDate';
const String kEventEndDate = 'eventEndDate';
const String kEventStatus = 'eventStatus';
const String kEventKey = 'eventKey';
const String kEventId = 'eventID';

class EventsController extends ChangeNotifier {
  //Events Controller
  List<Event> _active = [];
  List<Event> _archived = [];
  List<Event> _deleted = [];
  final _auth = FirebaseAuth.instance;
  final _firestoreReference = FirebaseFirestore.instance.collection('users');

  set archived(List<Event> events) {
    _archived = events;
    _archived.sort(
      (a, b) => a.dateStart.compareTo(b.dateStart),
    );
  }

  set setDeleted(List<Event> events) {
    _deleted = events;
    _deleted.sort(
      (a, b) => a.dateStart.compareTo(b.dateStart),
    );
  }

  set setEvents(List<Event> events) {
    _active = events;
    _active.sort(
      (a, b) => a.dateStart.compareTo(b.dateStart),
    );
  }

  List<Event> get setEvents => _active;
  List<Event> get archive => _archived;
  List<Event> get removed => _deleted;

  //TODO:: Use it in main screen
  int findNumberOfCompletedEvents() {
    int counter = 0;
    for (Event currentEvent in _active) {
      if (currentEvent.status) {
        counter++;
      }
    }
    return counter;
  }

  List<Event> getEventsAtDate(DateTime date) {
    List<Event> eventsAtDate = [];
    for (Event event in _active) {
      if (event.dateStart.day == date.day) {
        eventsAtDate.add(event);
      }
    }
    return eventsAtDate;
  }

  Future _createNotification(Event theEvent, bool toBeReminded) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'EventNotification',
      'EventNotification',
      'EventNotification',
      importance: Importance.high,
      priority: Priority.high,
    );
    var platformSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    if (toBeReminded) {
      try {
        final String currentTimeZone =
            await FlutterNativeTimezone.getLocalTimezone();
        final timeZone = tz.getLocation(currentTimeZone);
        final scheduleNotification =
            tz.TZDateTime.from(theEvent.reminder, timeZone);
        await localNotificationsPlugin.zonedSchedule(
          theEvent.id,
          'You have an upcomig event',
          'Hey you have ${theEvent.title} coming up soon',
          scheduleNotification,
          platformSpecifics,
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
      } catch (e) {
        print(e);
      }
    }
  }

  ///     Firebase cloud Firestore methods for events ///
  Future<void> toggleStatus(int index, bool isArchived) async {
    Event event = (isArchived) ? _archived[index] : _active[index];
    await _toggleEventStatus(event: event, isArchived: isArchived);
    event.toggleStatus();
    notifyListeners();
  }

  Future<void> addEvent(Event newEvent, bool toBeReminded) async {
    String key = UniqueKey().toString();
    int id = Random.secure().nextInt(10000);
    newEvent.setID = id;
    newEvent.setKey = key;
    _active.add(newEvent);
    _active.sort(
      (a, b) => a.dateStart.compareTo(b.dateStart),
    );
    await _addEventToFirebase(event: newEvent, dataBase: kEvent);
    await _createNotification(newEvent, toBeReminded);
    notifyListeners();
  }

  Future<void> moveToBin(int index, bool isArchived) async {
    Event event = (isArchived) ? _archived[index] : _active[index];
    await _moveToBinFirebase(event, isArchived);
    _deleted.add(event);
    _deleted.sort(
      (a, b) => a.dateStart.compareTo(b.dateStart),
    );
    (isArchived) ? _archived.removeAt(index) : _active.removeAt(index);
    notifyListeners();
  }

  Future<void> moveToArchive(int index) async {
    Event event = _active[index];
    _archiveEventFirebase(event);
    _archived.add(event);
    _archived.sort(
      (a, b) => a.dateStart.compareTo(b.dateStart),
    );
    _active.removeAt(index);
    notifyListeners();
  }

  Future<void> unArchiveEvent(int index) async {
    Event event = _archived[index];
    await _unArchiveEventFirebase(event);
    _active.add(event);
    _archived.removeAt(index);
    notifyListeners();
  }

  Future<void> purgeEvent(int index) async {
    Event event = _deleted[index];
    await _purgeEventFirebase(event);
    _deleted.removeAt(index);
    notifyListeners();
  }

  Future<void> recover(int index) async {
    Event event = _deleted[index];
    await _recoverEventFirebase(event);
    _active.add(_deleted[index]);
    _deleted.removeAt(index);
    notifyListeners();
  }

  Future<QuerySnapshot> _getEventQuery({String dataBase}) async {
    QuerySnapshot events = await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection(dataBase)
        .get();
    return events;
  }

  Future<String> _findEvent({Event event, String dataBase}) async {
    String docID;
    QuerySnapshot events = await _getEventQuery(dataBase: dataBase);
    for (var doc in events.docs) {
      if (doc.data()['eventKey'] == event.key) {
        docID = doc.id;
        break;
      }
    }
    return docID;
  }

  Future<void> _deleteEvent({String docID, String dataBase}) async {
    await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection(dataBase)
        .doc(docID)
        .delete();
  }

  Future<void> _addEventToFirebase({Event event, String dataBase}) async {
    await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection(dataBase)
        .add(
      {
        kEventTitle: event.title,
        kEventStartDate: event.dateStart,
        kEventEndDate: event.dateEnd,
        kEventStatus: event.status,
        kEventKey: event.key,
        kEventId: event.id
      },
    );
  }

  Future<void> _toggleEventStatus({Event event, bool isArchived}) async {
    String dataBase = (isArchived) ? kArchived : kEvent;
    String docID = await _findEvent(event: event, dataBase: dataBase);
    var document = await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection(dataBase)
        .doc(docID)
        .get();
    document.reference.update(
      {
        kEventStatus: event.status,
      },
    );
  }

  Future<void> _moveToBinFirebase(Event event, bool isArchived) async {
    String docID = '';
    if (!isArchived) {
      docID = await _findEvent(event: event, dataBase: kEvent);
      await _deleteEvent(docID: docID, dataBase: kEvent);
    } else {
      docID = await _findEvent(event: event, dataBase: kArchived);
      await _deleteEvent(docID: docID, dataBase: kArchived);
    }
    await _addEventToFirebase(event: event, dataBase: kDeleted);
  }

  Future<void> _archiveEventFirebase(Event event) async {
    String docID = await _findEvent(event: event, dataBase: kEvent);
    await _deleteEvent(docID: docID, dataBase: kEvent);
    await _addEventToFirebase(event: event, dataBase: kArchived);
  }

  Future<void> _unArchiveEventFirebase(Event event) async {
    String docID = await _findEvent(event: event, dataBase: kArchived);
    await _deleteEvent(docID: docID, dataBase: kArchived);
    await _addEventToFirebase(event: event, dataBase: kEvent);
  }

  Future<void> _purgeEventFirebase(Event event) async {
    String docID = await _findEvent(event: event, dataBase: kDeleted);
    await _deleteEvent(docID: docID, dataBase: kDeleted);
  }

  Future<void> _recoverEventFirebase(Event event) async {
    String docID = await _findEvent(event: event, dataBase: kDeleted);
    await _deleteEvent(docID: docID, dataBase: kDeleted);
    await _addEventToFirebase(event: event, dataBase: kEvent);
  }

  Future<void> fetchEvents() async {
    await _fetchEvents(dataBase: kEvent);
    await _fetchEvents(dataBase: kArchived);
    await _fetchEvents(dataBase: kDeleted);
  }

  Future<void> _fetchEvents({String dataBase}) async {
    var eventsQS = await _getEventQuery(dataBase: dataBase);
    List<Event> eventList = [];
    for (var doc in eventsQS.docs) {
      eventList.add(
        Event.fromParam(
          doc.get(kEventTitle),
          doc.get(kEventStartDate).toDate(),
          doc.get(kEventEndDate).toDate(),
          doc.get(kEventKey),
          doc.get(kEventId),
        ),
      );
    }
    if (dataBase == kEvent) {
      setEvents = eventList;
    } else if (dataBase == kArchived) {
      archived = eventList;
    } else {
      setDeleted = eventList;
    }
  }
}
