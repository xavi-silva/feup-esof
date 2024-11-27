import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../control/data_controller.dart';
import '../../../main.dart';
import '../../pages/events/edit_event.dart';
import '../../pages/events/event_page.dart';

class ParticipantButtons extends StatelessWidget {
  final bool isOldEvent;
  final String userId;
  final DocumentReference eventRef;
  final DocumentReference userRef;
  final bool isParticipant;
  final int participantsCount;
  final EventPage widget;
  final DataController dataController;

  const ParticipantButtons({
    Key? key,
    required this.isOldEvent,
    required this.userId,
    required this.eventRef,
    required this.userRef,
    required this.isParticipant,
    required this.participantsCount,
    required this.widget,
    required this.dataController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (isParticipant && userId != widget.organizerId && !isOldEvent)
          Positioned(
            bottom: 10,
            right: 10,
            child: GestureDetector(
              onTap: () async {
                await eventRef.collection('participants').doc(userId).delete();
                await userRef.collection('events').doc(widget.eventId).delete();
                await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Success!'),
                    content: Text(
                        'You have successfully withdrawn from the ${widget.name} cleanup'),
                    actions: [
                      TextButton(
                        child: Text('OK'),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                );
                navigatorKey.currentState!.popUntil((route) => route.isFirst);
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1),
                  shape: BoxShape.circle,
                  color: Color.fromARGB(255, 225, 247, 219),
                ),
                child: Icon(
                  Icons.cancel,
                  size: 30,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        if (!isParticipant &&
            userId != widget.organizerId &&
            !isOldEvent &&
            int.parse(widget.capacity) > participantsCount)
          Positioned(
            bottom: 10,
            right: 10,
            child: GestureDetector(
              onTap: () async {
                await dataController.getParticipantCount(widget.eventId);
                if (int.parse(widget.capacity) > participantsCount) {
                  await userRef
                      .collection('events')
                      .doc(widget.eventId)
                      .set({});
                  await eventRef.collection('participants').doc(userId).set({});
                  await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Success!'),
                      content: Text(
                          'You have successfully joined the ${widget.name} cleanup'),
                      actions: [
                        TextButton(
                          child: Text('OK'),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  );
                  navigatorKey.currentState!.popUntil((route) => route.isFirst);
                } else {
                  await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Error!'),
                      content: Text(
                          'Error! The ${widget.name} cleanup is already full'),
                      actions: [
                        TextButton(
                          child: Text('OK'),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1),
                  shape: BoxShape.circle,
                  color: Color.fromARGB(255, 225, 247, 219),
                ),
                child: Icon(
                  Icons.cleaning_services_rounded,
                  size: 30,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        if ((userId == widget.organizerId && !isOldEvent))
          Positioned(
            bottom: 10,
            right: 10,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => EditEvent(
                    EventId: widget.eventId,
                    date: widget.date,
                    time: widget.startTime,
                    capacity: widget.capacity,
                    description: widget.description,
                  ),
                ));
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1),
                  shape: BoxShape.circle,
                  color: Color.fromARGB(255, 225, 247, 219),
                ),
                child: Icon(
                  Icons.edit,
                  size: 30,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        if ((userId == widget.organizerId && !isOldEvent) ||
            dataController.userInfo!.get('isAdmin'))
          Positioned(
            bottom: 10,
            left: 10,
            child: GestureDetector(
              onTap: () async {
                await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Confirmation'),
                    content: Text(
                        'Are you sure you want to remove the ${widget.name} cleanup?'),
                    actions: [
                      TextButton(
                        child: Text('NO'),
                        onPressed: () => Navigator.pop(context),
                      ),
                      TextButton(
                        child: Text('YES'),
                        onPressed: () async {
                          await dataController.removeEvent(
                              widget.eventId, widget.imageUrl, widget.name);
                          Navigator.pop(context);
                          await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Success!'),
                              content: Text(
                                  'You have successfully removed the ${widget.name} cleanup'),
                              actions: [
                                TextButton(
                                  child: Text('OK'),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ],
                            ),
                          );
                          navigatorKey.currentState!
                              .popUntil((route) => route.isFirst);
                        },
                      ),
                    ],
                  ),
                );
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1),
                  shape: BoxShape.circle,
                  color: Color.fromARGB(255, 225, 247, 219),
                ),
                child: Icon(
                  Icons.delete,
                  size: 30,
                  color: Colors.black,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
