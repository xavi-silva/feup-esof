import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sweepspot/view/pages/events/event_page.dart';

class EventCard extends StatefulWidget {
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

  EventCard({
    required this.eventDateTime,
    required this.name,
    required this.date,
    required this.imageUrl,
    required this.description,
    required this.capacity,
    required this.location,
    required this.organizerId,
    required this.startTime,
    required this.eventId,
  });

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  int participantsCount = 0;
  //late StreamSubscription<QuerySnapshot> _subscription;

  @override
  void initState() {
    super.initState();
    _subscribeToEvents();
    _getParticipantCount();
  }

  @override
  void dispose() {
    //  _subscription.cancel();
    super.dispose();
  }

  void _subscribeToEvents() {
    FirebaseFirestore.instance
        .collection('Event')
        .where('datetime', isGreaterThan: DateTime.now().toString())
        .orderBy('datetime')
        .snapshots()
        .listen((snapshot) {
      snapshot.docs.forEach((eventDoc) {
        String eventId = eventDoc.id;
        FirebaseFirestore.instance
            .collection('Event')
            .doc(eventId)
            .collection('participants')
            .snapshots()
            .listen((participantsSnapshot) {
          _getParticipantCount();
        });
      });
    });
  }

  Future<void> _getParticipantCount() async {
    CollectionReference eventParticipantsCollection = FirebaseFirestore.instance
        .collection('Event')
        .doc(widget.eventId)
        .collection('participants');

    QuerySnapshot participantsSnapshot =
        await eventParticipantsCollection.get();

    if (mounted) {
      setState(() {
        participantsCount = participantsSnapshot.size;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EventPage(
                  eventDateTime: widget.eventDateTime,
                  name: widget.name,
                  date: widget.date,
                  imageUrl: widget.imageUrl,
                  description: widget.description,
                  capacity: widget.capacity,
                  location: widget.location,
                  organizerId: widget.organizerId,
                  eventId: widget.eventId,
                  startTime: widget.startTime,
                )));
      },
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Color(0xFFA5E4C6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Color(0xFFA5E4C6),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(widget.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Color(0xFFE1F7DB),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: 10),
                      Expanded(
                        flex: 5,
                        child: Text(
                          widget.name,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, color: Colors.black),
                          Text(
                            widget.date,
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                      SizedBox(width: 10),
                      Row(
                        children: [
                          Icon(Icons.person, color: Colors.black),
                          Text(
                            '$participantsCount / ${widget.capacity}',
                            style: TextStyle(color: Colors.black),
                          ),
                          SizedBox(width: 10),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
