import 'package:cloud_firestore/cloud_firestore.dart';

class DataController {
  String uid;
  FirebaseFirestore firestore;
  DocumentSnapshot? userInfo;
  List<DocumentSnapshot>? userEvents;

  DataController({required this.uid, required this.firestore}) {
    getUserInfo();
    getUserEvents();
  }

  get authController => null;

  getUserInfo() async {
    userInfo = await firestore.collection('users').doc(uid).get();

    firestore.collection('users').doc(uid).snapshots().listen((event) {
      userInfo = event;
    });
  }

  getUserEvents() async {
    try {
      DocumentReference userRef = firestore.collection('users').doc(uid);
      var userSnapshot = await userRef.get();
      if (!userSnapshot.exists) {
        return;
      }

      QuerySnapshot prevEventsQuery = await firestore
          .collection('users')
          .doc(uid)
          .collection('events')
          .get();

      List<String> eventIds =
          prevEventsQuery.docs.map((doc) => doc.id).toList();
      QuerySnapshot helper = await firestore
          .collection('Event')
          .where(FieldPath.documentId, whereIn: eventIds)
          .get();

      userEvents = helper.docs;
    } catch (e) {
      print('Error getting user events: $e');
    }
  }

  Future<bool> isUserParticipant(String eventId) async {
    try {
      CollectionReference eventsCollection = firestore.collection('Event');
      DocumentReference eventRef = eventsCollection.doc(eventId);
      DocumentSnapshot participantSnapshot =
          await eventRef.collection('participants').doc(uid).get();
      return participantSnapshot.exists;
    } catch (e) {
      print('Error checking participant: $e');
      return false;
    }
  }

  Future<void> removeEvent(
      String eventId, String imageUrl, String eventTitle) async {
    try {
      CollectionReference participantsRef =
          firestore.collection('Event').doc(eventId).collection('participants');

      CollectionReference commentsRef =
          firestore.collection('Event').doc(eventId).collection('review');

      // Exclude all comments related to the event
      QuerySnapshot commentsSnapshot = await commentsRef.get();
      for (QueryDocumentSnapshot commentDoc in commentsSnapshot.docs) {
        await commentDoc.reference.delete();
      }

      // Exclude all participants of the event and notify each of them
      QuerySnapshot participantsSnapshot = await participantsRef.get();
      List<String> participantIds = [];
      for (QueryDocumentSnapshot participantDoc in participantsSnapshot.docs) {
        String userId = participantDoc.id;

        // Remove the participant from the event
        await participantDoc.reference.delete();

        // Remove the event from the user's collection of events
        await firestore
            .collection('users')
            .doc(userId)
            .collection('events')
            .doc(eventId)
            .delete();

        // Add the participant ID to the list for notification
        participantIds.add(userId);
      }

      // Exclude the event document itself
      await firestore.collection('Event').doc(eventId).delete();

      print('Event removed successfully and notifications sent.');
    } catch (e) {
      print('Error removing the event: $e');
    }
  }

  Future<void> loadComment(String eventId, String text) async {
    if (text.isNotEmpty) {
      try {
        String formattedDateTime = DateTime.now().year.toString() +
            '-' +
            DateTime.now().month.toString().padLeft(2, '0') +
            '-' +
            DateTime.now().day.toString().padLeft(2, '0') +
            ' ' +
            DateTime.now().hour.toString().padLeft(2, '0') +
            ':' +
            DateTime.now().minute.toString().padLeft(2, '0');

        await firestore
            .collection('Event')
            .doc(eventId)
            .collection('review')
            .add({
          'userid': uid,
          'text': text,
          'date': formattedDateTime,
        });
        print('Comment added successfully to the review collection!');
      } catch (e) {
        print('Error adding comment to the review collection: $e');
      }
    } else {
      print("Text is empty");
    }
  }

  Future<int> getParticipantCount(String eventId) async {
    CollectionReference eventParticipantsCollection =
        firestore.collection('Event').doc(eventId).collection('participants');

    QuerySnapshot participantsSnapshot =
        await eventParticipantsCollection.get();
    return participantsSnapshot.size;
  }

  Future<QuerySnapshot<Map<String, dynamic>>?> getComments(
      String eventId) async {
    try {
      final querySnapshot = await firestore
          .collection('Event')
          .doc(eventId)
          .collection('review')
          .get();
      return querySnapshot;
    } catch (e) {
      print('Error fetching comments: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> getUserData(String id) async {
    try {
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(id).get();

      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>;
      } else {
        print('User not found');
        return {}; // Return an empty map if user not found
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return {}; // Return an empty map in case of error
    }
  }

  void updateUidAndReloadData(String newUid) {
    uid = newUid;
    getUserInfo();
    getUserEvents();
  }
}
