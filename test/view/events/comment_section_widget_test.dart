import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sweepspot/view/widget/events/comment_section_widget.dart';

class MockDataController extends Mock {
  Future<QuerySnapshot> getComments(String eventId);
  Future<DocumentSnapshot> getUserData(String userId);
  Future<void> loadComment(String eventId, String comment);
}

void main() {
  final mockDataController = MockDataController();

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: Scaffold(
        body: CommentSection(
          allComments: [],
          userId: 'user1',
          organizerId: 'organizer1',
          eventId: 'event1',
          dataController: mockDataController,
        ),
      ),
    );
  }

  setUp(() {
    reset(mockDataController);
  });

  testWidgets('renders CommentSection widget', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Comments (0)'), findsOneWidget);
    expect(find.text('Add a comment...'), findsOneWidget);
  });

  testWidgets('shows comment input field on button press',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    await tester.tap(find.byIcon(Icons.chat));
    await tester.pump();

    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Write a comment...'), findsOneWidget);
  });
}
