import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sweepspot/control/data_controller.dart';

void main() {
  FakeFirebaseFirestore? fakeFirebaseFirestore;
  setUp(() {
    fakeFirebaseFirestore = FakeFirebaseFirestore();
  });
  test('getFromDocument gets data from a given document', () async {
    const String uid = "userid";
    final DataController dataController =
        DataController(uid: uid, firestore: fakeFirebaseFirestore!);

    const String collectionPath = 'users';
    const String documentPath = uid;

    final DocumentReference<Map<String, dynamic>> documentReference =
        fakeFirebaseFirestore!.collection(collectionPath).doc(documentPath);

    const Map<String, dynamic> data = {
      'first': 'John',
      'last': 'Doe',
      'username': 'johndoe_1',
      'image': 'https://url.com'
    };
    await documentReference.set(data);

    final DocumentSnapshot? expectedDocumentSnapshot =
        await documentReference.get();
    await dataController.getUserInfo();
    final DocumentSnapshot? actualDocumentSnapshot = dataController.userInfo;
    final expectedData = expectedDocumentSnapshot?.data();
    final actualData = actualDocumentSnapshot?.data();

    print('Expected Data: $expectedData');
    print('Actual Data: $actualData');

    expect(actualDocumentSnapshot?.get('first'),
        expectedDocumentSnapshot?.get('first'));
    expect(actualDocumentSnapshot?.get('last'),
        expectedDocumentSnapshot?.get('last'));
    expect(actualDocumentSnapshot?.get('username'),
        expectedDocumentSnapshot?.get('username'));
    expect(actualDocumentSnapshot?.get('image'),
        expectedDocumentSnapshot?.get('image'));
  });
  test('getUserEvents returns empty list if no events found', () async {
    final DataController dataController =
        DataController(uid: 'userid', firestore: fakeFirebaseFirestore!);
    const String collectionPath = 'users';
    const String documentPath = 'userid';

    await fakeFirebaseFirestore!
        .collection(collectionPath)
        .doc(documentPath)
        .set({'username': 'test_user', 'events': []});

    await dataController.getUserEvents();
    expect(dataController.userEvents!.isEmpty, true);
  });
  test('getUserEvents retrieves user events', () async {
    const String uid = "userid";
    final DataController dataController =
        DataController(uid: uid, firestore: fakeFirebaseFirestore!);

    const String collectionPath = 'users';
    const String documentPath = uid;

    final DocumentReference<Map<String, dynamic>> documentReference =
        fakeFirebaseFirestore!.collection(collectionPath).doc(documentPath);
    const Map<String, dynamic> data = {
      'first': 'John',
      'last': 'Doe',
      'username': 'johndoe_1',
      'image': 'https://url.com',
      'events': []
    };
    await documentReference.set(data);
    await fakeFirebaseFirestore!
        .collection('users')
        .doc(uid)
        .collection('events')
        .doc('event1')
        .set({'eventName': 'Event 1'});

    await fakeFirebaseFirestore!
        .collection('users')
        .doc(uid)
        .collection('events')
        .doc('event2')
        .set({'eventName': 'Event 2'});

    final List<String> eventIds = ['event1', 'event2'];
    for (int i = 0; i < eventIds.length; i++) {
      final DocumentReference<Map<String, dynamic>> eventReference =
          fakeFirebaseFirestore!.collection('Event').doc(eventIds[i]);
      await eventReference.set({'eventName': 'Event ${i + 1}'});
    }
    await dataController.getUserEvents();

    expect(dataController.userEvents!.length, 2);
    expect(dataController.userEvents![0].id, 'event1');
    expect(dataController.userEvents![1].id, 'event2');
    expect(dataController.userEvents![0]['eventName'], 'Event 1');
    expect(dataController.userEvents![1]['eventName'], 'Event 2');
  });

  test('isUserParticipant checks participant status', () async {
    const String uid = "userid";
    final DataController dataController =
        DataController(uid: uid, firestore: fakeFirebaseFirestore!);

    const String eventId = 'event1';

    await fakeFirebaseFirestore!
        .collection('Event')
        .doc(eventId)
        .collection('participants')
        .doc(uid)
        .set({'userId': uid});
    bool isParticipant = await dataController.isUserParticipant(eventId);
    expect(isParticipant, true);
    isParticipant = await dataController.isUserParticipant('nonexistent_event');
    expect(isParticipant, false);
  });
  test('isUserParticipant returns false if user is not a participant',
      () async {
    final DataController dataController =
        DataController(uid: 'userid', firestore: fakeFirebaseFirestore!);
    const String eventId = 'event1';
    bool isParticipant = await dataController.isUserParticipant(eventId);
    expect(isParticipant, false);
  });

  test('removeEvent removes event and related data', () async {
    const String uid = "userid";
    final DataController dataController =
        DataController(uid: uid, firestore: fakeFirebaseFirestore!);

    const String eventId = 'event1';
    const String imageUrl = 'https://example.com/image.jpg';
    const String eventTitle = 'Event 1';
    await fakeFirebaseFirestore!
        .collection('Event')
        .doc(eventId)
        .collection('participants')
        .doc(uid)
        .set({'userId': uid});
    await fakeFirebaseFirestore!
        .collection('Event')
        .doc(eventId)
        .collection('review')
        .add({'userid': uid, 'text': 'Comment 1', 'date': '2024-04-30 12:00'});

    await fakeFirebaseFirestore!
        .collection('Event')
        .doc(eventId)
        .collection('review')
        .add({'userid': uid, 'text': 'Comment 2', 'date': '2024-04-30 12:00'});

    await dataController.removeEvent(eventId, imageUrl, eventTitle);

    DocumentSnapshot eventSnapshot =
        await fakeFirebaseFirestore!.collection('Event').doc(eventId).get();
    expect(eventSnapshot.exists, false);

    QuerySnapshot commentsSnapshot = await fakeFirebaseFirestore!
        .collection('Event')
        .doc(eventId)
        .collection('review')
        .get();
    expect(commentsSnapshot.docs.isEmpty, true);

    DocumentSnapshot participantSnapshot = await fakeFirebaseFirestore!
        .collection('Event')
        .doc(eventId)
        .collection('participants')
        .doc(uid)
        .get();
    expect(participantSnapshot.exists, false);
  });
  test('removeEvent does not throw error if event does not exist', () async {
    final DataController dataController =
        DataController(uid: 'userid', firestore: fakeFirebaseFirestore!);
    const String eventId = 'non_existing_event';
    const String imageUrl = 'https://example.com/image.jpg';
    const String eventTitle = 'Non Existing Event';
    await dataController.removeEvent(eventId, imageUrl, eventTitle);
    // No assertion needed, test passes if no error is thrown
  });
  test('loadComment does not add comment if text is empty', () async {
    const String uid = "userid";
    final DataController dataController =
        DataController(uid: uid, firestore: fakeFirebaseFirestore!);
    const String eventId = 'event1';
    const String commentText = '';
    await dataController.loadComment(eventId, commentText);

    final QuerySnapshot<Map<String, dynamic>> commentSnapshot =
        await fakeFirebaseFirestore!
            .collection('Event')
            .doc(eventId)
            .collection('review')
            .get();
    expect(commentSnapshot.docs.length, 0);
  });

  test('loadComment adds comment to the review collection', () async {
    const String uid = "userid";
    final DataController dataController =
        DataController(uid: uid, firestore: fakeFirebaseFirestore!);
    const String eventId = 'event1';
    const String commentText = 'This is a test comment';
    await dataController.loadComment(eventId, commentText);

    final QuerySnapshot<Map<String, dynamic>> commentSnapshot =
        await fakeFirebaseFirestore!
            .collection('Event')
            .doc(eventId)
            .collection('review')
            .get();

    expect(commentSnapshot.docs.length, 1);
    final Map<String, dynamic> commentData = commentSnapshot.docs.first.data();
    expect(commentData['userid'], uid);
    expect(commentData['text'], commentText);
    final String formattedDateTime = DateTime.now().year.toString() +
        '-' +
        DateTime.now().month.toString().padLeft(2, '0') +
        '-' +
        DateTime.now().day.toString().padLeft(2, '0') +
        ' ' +
        DateTime.now().hour.toString().padLeft(2, '0') +
        ':' +
        DateTime.now().minute.toString().padLeft(2, '0');
    expect(commentData['date'], formattedDateTime);
  });

  test('getParticipantCount retrieves participant count', () async {
    final DataController dataController =
        DataController(uid: 'userid', firestore: fakeFirebaseFirestore!);

    const String eventId = 'event1';
    const int expectedParticipantCount = 5;
    for (int i = 0; i < expectedParticipantCount; i++) {
      await fakeFirebaseFirestore!
          .collection('Event')
          .doc(eventId)
          .collection('participants')
          .doc('participant$i')
          .set({'name': 'Participant $i'});
    }
    final int participantCount =
        await dataController.getParticipantCount(eventId);
    expect(participantCount, expectedParticipantCount);
  });
  test('getParticipantCount returns 0 for non-existing event', () async {
    final DataController dataController =
        DataController(uid: 'userid', firestore: fakeFirebaseFirestore!);
    const String nonExistingEventId = 'non_existing_event';

    final int participantCount =
        await dataController.getParticipantCount(nonExistingEventId);

    expect(participantCount, 0);
  });
  test('getComments retrieves comments for the event', () async {
    final DataController dataController =
        DataController(uid: 'userid', firestore: fakeFirebaseFirestore!);
    const String eventId = 'event1';
    const List<Map<String, dynamic>> commentsData = [
      {'userid': 'user1', 'text': 'Comment 1', 'date': '2024-04-30 12:00'},
      {'userid': 'user2', 'text': 'Comment 2', 'date': '2024-04-30 12:30'},
      {'userid': 'user3', 'text': 'Comment 3', 'date': '2024-04-30 13:00'},
    ];

    for (int i = 0; i < commentsData.length; i++) {
      await fakeFirebaseFirestore!
          .collection('Event')
          .doc(eventId)
          .collection('review')
          .doc('comment$i')
          .set(commentsData[i]);
    }
    final QuerySnapshot<Map<String, dynamic>>? commentsSnapshot =
        await dataController.getComments(eventId);
    expect(commentsSnapshot, isNotNull);
    expect(commentsSnapshot!.docs.length, commentsData.length);

    for (int i = 0; i < commentsData.length; i++) {
      final Map<String, dynamic> commentData = commentsSnapshot.docs[i].data();
      expect(commentData['userid'], commentsData[i]['userid']);
      expect(commentData['text'], commentsData[i]['text']);
      expect(commentData['date'], commentsData[i]['date']);
    }
  });

  test('getComments returns empty list if no comments found', () async {
    final DataController dataController =
        DataController(uid: 'userid', firestore: fakeFirebaseFirestore!);
    const String eventId = 'event1';

    final QuerySnapshot<Map<String, dynamic>>? commentsSnapshot =
        await dataController.getComments(eventId);
    expect(commentsSnapshot, isNotNull);
    expect(commentsSnapshot!.docs.isEmpty, true);
  });

  test('getComments returns empty for non-existing event', () async {
    final DataController dataController =
        DataController(uid: 'userid', firestore: fakeFirebaseFirestore!);
    const String nonExistingEventId = 'non_existing_event';

    final QuerySnapshot<Map<String, dynamic>>? commentsSnapshot =
        await dataController.getComments(nonExistingEventId);

    expect(commentsSnapshot!.docs.length, 0);
  });

  test('getUserData retrieves user data for the given user ID', () async {
    final DataController dataController =
        DataController(uid: 'userid', firestore: fakeFirebaseFirestore!);
    const String userId = 'user1';
    const Map<String, dynamic> userData = {
      'username': 'test_user',
      'email': 'test@example.com',
    };
    await fakeFirebaseFirestore!.collection('users').doc(userId).set(userData);
    final Map<String, dynamic> result =
        await dataController.getUserData(userId);
    expect(result['username'], userData['username']);
    expect(result['email'], userData['email']);
  });

  test('getUserData returns an empty map if user not found', () async {
    final DataController dataController =
        DataController(uid: 'userid', firestore: fakeFirebaseFirestore!);
    final Map<String, dynamic> result =
        await dataController.getUserData('non_existing_user');
    expect(result, isEmpty);
  });
}
