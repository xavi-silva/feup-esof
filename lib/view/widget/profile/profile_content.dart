import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sweepspot/view/widget/profile/event_card.dart';

class ProfileContent extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String username;
  final String image;
  final int cleanupsCount;
  final List<DocumentSnapshot>? filteredEvents;

  ProfileContent({
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.image,
    required this.cleanupsCount,
    required this.filteredEvents,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 50),
        ProfileImage(image: image),
        SizedBox(height: 10),
        ProfileName(firstName: firstName, lastName: lastName),
        ProfileUsername(username: username),
        SizedBox(height: 10),
        CleanupsCount(cleanupsCount: cleanupsCount),
        SizedBox(height: 20),
        (filteredEvents != null && filteredEvents!.isNotEmpty)
            ? Expanded(
                child: PastEventsList(events: filteredEvents!),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  'No past events',
                  style: TextStyle(
                    fontFamily: 'Readex Pro',
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
      ],
    );
  }
}

class ProfileImage extends StatelessWidget {
  final String image;

  ProfileImage({required this.image});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 56,
      backgroundColor: Colors.white,
      backgroundImage: image.isEmpty
          ? AssetImage('assets/profile.png')
          : NetworkImage(image) as ImageProvider,
    );
  }
}

class ProfileName extends StatelessWidget {
  final String firstName;
  final String lastName;

  ProfileName({required this.firstName, required this.lastName});

  @override
  Widget build(BuildContext context) {
    return Text(
      "$firstName $lastName",
      style: TextStyle(
        fontFamily: 'Outfit',
        color: Colors.black,
        fontSize: 24,
      ),
    );
  }
}

class ProfileUsername extends StatelessWidget {
  final String username;

  ProfileUsername({required this.username});

  @override
  Widget build(BuildContext context) {
    return Text(
      username,
      style: TextStyle(
        fontFamily: 'Readex Pro',
        color: Colors.black,
        fontSize: 14,
      ),
    );
  }
}

class CleanupsCount extends StatelessWidget {
  final int cleanupsCount;

  CleanupsCount({required this.cleanupsCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Text(
              cleanupsCount.toString(),
              style: TextStyle(
                fontFamily: 'Outfit',
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'clean-ups',
              style: TextStyle(
                fontFamily: 'Readex Pro',
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class PastEventsTitle extends StatelessWidget {
  final bool hasEvents;

  PastEventsTitle({required this.hasEvents});

  @override
  Widget build(BuildContext context) {
    return Text(
      hasEvents ? 'Past events' : 'No past events',
      style: TextStyle(
        fontFamily: 'Readex Pro',
        fontSize: 20,
        color: Colors.black,
      ),
    );
  }
}

class PastEventsList extends StatelessWidget {
  final List<DocumentSnapshot> events;

  PastEventsList({required this.events});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        var event = events[index];
        return ProfileEventCard(event: event);
      },
    );
  }
}
