import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sweepspot/view/widget/events/event_list_widget.dart';

// Mock class for Firestore
class MockQuerySnapshot extends Mock
    implements QuerySnapshot<Map<String, dynamic>> {}

class MockStream extends Mock
    implements Stream<QuerySnapshot<Map<String, dynamic>>> {}

void main() {
  group('EventList Widget Tests', () {
    late StreamController<QuerySnapshot<Map<String, dynamic>>> streamController;
    late MockQuerySnapshot mockQuerySnapshot;

    setUp(() {
      streamController =
          StreamController<QuerySnapshot<Map<String, dynamic>>>();
      mockQuerySnapshot = MockQuerySnapshot();
    });

    tearDown(() {
      streamController.close();
    });

    Widget createWidgetUnderTest(
        Stream<QuerySnapshot<Map<String, dynamic>>> stream) {
      return MaterialApp(
        home: Scaffold(
          body: EventList(events: stream),
        ),
      );
    }

    testWidgets('Displays loading indicator when waiting for data',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(streamController.stream));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Displays error message on error', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(streamController.stream));
      await tester.pump();

      streamController.addError(Exception('Erro ao carregar os dados'));

      await tester.pump();

      expect(find.text('Erro ao carregar os dados'), findsOneWidget);
    });
  });
}
