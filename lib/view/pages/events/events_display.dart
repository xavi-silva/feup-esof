import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sweepspot/view/pages/events/create_event_page.dart';
import 'package:sweepspot/view/widget/events/event_list_widget.dart';

class EventsDisplay extends StatefulWidget {
  final FirebaseFirestore firestoreInstance;

  EventsDisplay({required this.firestoreInstance});

  @override
  _EventsDisplayState createState() => _EventsDisplayState();
}

class _EventsDisplayState extends State<EventsDisplay> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> futureEvents;
  late Stream<QuerySnapshot<Map<String, dynamic>>> pastEvents;

  @override
  void initState() {
    super.initState();

    futureEvents = widget.firestoreInstance
        .collection('Event')
        .where('datetime', isGreaterThan: DateTime.now().toString())
        .orderBy('datetime')
        .snapshots();
    pastEvents = widget.firestoreInstance
        .collection('Event')
        .where('datetime', isLessThanOrEqualTo: DateTime.now().toString())
        .orderBy('datetime')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          backgroundColor: Color(0xFFE1F7DB),
          iconTheme: IconThemeData(color: Color(0xFFE1F7DB)),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 10, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Create an Event',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add, color: Colors.black, size: 24),
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CreateEventPage(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFFA5E4C6),
        body: DefaultTabController(
          length: 2,
          initialIndex: 1,
          child: Column(
            children: [
              TabBar(
                tabs: [
                  Tab(text: 'Past Events'),
                  Tab(text: 'Future Events'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    EventList(
                      events: pastEvents,
                    ),
                    EventList(
                      events: futureEvents,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
