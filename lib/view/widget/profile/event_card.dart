import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sweepspot/view/pages/events/event_page.dart';

class ProfileEventCard extends StatelessWidget {
  final DocumentSnapshot event;

  ProfileEventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    String eventName = event['name'];
    String eventImage = event['image'];
    String eventDescription = event['description'];
    String eventCapacity = event['maxCapacity'];
    GeoPoint eventLocation = event['location'];
    String eventOrganizerId = event['organizer'];
    String dateTime = event['datetime'];
    String eventId = event.id;
    String eventDate = dateTime.split(" ")[0];
    String startTime = dateTime.split(" ")[1];

    return Padding(
      padding: EdgeInsets.all(10),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EventPage(
                eventDateTime: dateTime,
                name: eventName,
                date: eventDate,
                imageUrl: eventImage,
                description: eventDescription,
                capacity: eventCapacity,
                location: eventLocation,
                eventId: eventId,
                organizerId: eventOrganizerId,
                startTime: startTime,
              ),
            ),
          );
        },
        child: Column(
          children: [
            _buildEventImage(eventImage),
            _buildEventDetails(eventName, eventDate),
          ],
        ),
      ),
    );
  }

  Widget _buildEventImage(String eventImage) {
    return Container(
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(
        color: Color(0xFFA5E4C6),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        image: DecorationImage(
          image: NetworkImage(eventImage),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildEventDetails(String eventName, String eventDate) {
    return Container(
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
              eventName,
              textAlign: TextAlign.start,
              style: TextStyle(color: Colors.black),
            ),
          ),
          SizedBox(width: 10),
          Row(
            children: [
              Icon(Icons.calendar_today, color: Colors.black),
              Text(
                eventDate,
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
          SizedBox(width: 10),
        ],
      ),
    );
  }
}
