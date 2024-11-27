import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sweepspot/view/widget/events/event_card_widget.dart';

class EventList extends StatelessWidget {
  final Stream<QuerySnapshot<Map<String, dynamic>>> events;
  EventList({Key? key, required this.events}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: StreamBuilder(
        stream: events,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar os dados'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical: 15),
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              String eventName = data['name'];
              String imageUrl = data['image'];
              String eventDateTime = data['datetime'];
              GeoPoint location = data['location'];
              String capacity = data['maxCapacity'];
              String description = data['description'];
              String organizerId = data['organizer'];
              String eventId = document.id;
              String eventDate = eventDateTime.split(" ")[0];
              String startTime = eventDateTime.split(" ")[1];
              return EventCard(
                eventDateTime: eventDateTime,
                name: eventName,
                date: eventDate.split('-')[2] +
                    '-' +
                    eventDate.split('-')[1] +
                    '-' +
                    eventDate.split('-')[0],
                imageUrl: imageUrl,
                location: location,
                capacity: capacity,
                description: description,
                startTime: startTime,
                organizerId: organizerId,
                eventId: eventId,
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
