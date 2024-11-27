import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sweepspot/control/data_controller.dart';
import 'package:sweepspot/view/widget/events/comment_section_widget.dart';
import 'package:sweepspot/view/widget/events/map_widget.dart';

import '../../widget/events/event_header_widget.dart';
import '../../widget/events/participant_buttons_widget.dart';

class EventPage extends StatefulWidget {
  final String eventDateTime;
  final String name;
  final String date;
  final String imageUrl;
  final String description;
  final String capacity;
  final GeoPoint location;
  final String organizerId;
  final String startTime;
  final String eventId;

  const EventPage({
    Key? key,
    required this.eventDateTime,
    required this.name,
    required this.date,
    required this.imageUrl,
    required this.description,
    required this.capacity,
    required this.eventId,
    required this.location,
    required this.organizerId,
    required this.startTime,
  }) : super(key: key);

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  late DataController dataController;
  bool _isLoading = true;
  bool isParticipant = false;
  int participantsCount = 0;
  List<Map<String, dynamic>> allComments = [];

  @override
  void initState() {
    super.initState();
    dataController = DataController(
      uid: FirebaseAuth.instance.currentUser!.uid,
      firestore: FirebaseFirestore.instance,
    );
    _fetchEventData();
  }

  Future<void> _fetchEventData() async {
    try {
      participantsCount =
          await dataController.getParticipantCount(widget.eventId);
      isParticipant = await dataController.isUserParticipant(widget.eventId);
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching event data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime eventDateTimeAux = DateTime.parse(widget.eventDateTime + ":30");
    bool isOldEvent = eventDateTimeAux.isBefore(DateTime.now());

    String userId = FirebaseAuth.instance.currentUser!.uid;
    CollectionReference eventsCollection =
        FirebaseFirestore.instance.collection('Event');
    DocumentReference eventRef = eventsCollection.doc(widget.eventId);

    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');
    DocumentReference userRef = usersCollection.doc(userId);

    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _buildEventDetails(isOldEvent, userId, eventRef, userRef),
    );
  }

  Widget _buildEventDetails(bool isOldEvent, String userId,
      DocumentReference eventRef, DocumentReference userRef) {
    return Container(
      color: Color(0xFFA5E4C6),
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: Color.fromARGB(255, 225, 247, 219),
              automaticallyImplyLeading: true,
              expandedHeight: 150.0,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.network(
                  widget.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ];
        },
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EventHeader(
                    name: widget.name,
                    date: widget.date,
                    startTime: widget.startTime,
                    description: widget.description,
                    participantsCount: participantsCount,
                    capacity: widget.capacity,
                    isParticipant: isParticipant,
                  ),
                  EventDescription(widget: widget),
                  CommentSection(
                    allComments: allComments,
                    userId: userId,
                    organizerId: widget.organizerId,
                    eventId: widget.eventId,
                    dataController: dataController,
                  ),
                ],
              ),
            ),
            ParticipantButtons(
              isOldEvent: isOldEvent,
              userId: userId,
              eventRef: eventRef,
              userRef: userRef,
              isParticipant: isParticipant,
              participantsCount: participantsCount,
              widget: widget,
              dataController: dataController,
            ),
          ],
        ),
      ),
    );
  }
}

class EventDescription extends StatelessWidget {
  final EventPage widget;

  const EventDescription({Key? key, required this.widget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        width: 400,
        height: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: MapWidget(initialGeoPoint: widget.location),
      ),
    );
  }
}

class MapSection extends StatelessWidget {
  final EventPage widget;

  const MapSection({Key? key, required this.widget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: MapWidget(initialGeoPoint: widget.location),
    );
  }
}
