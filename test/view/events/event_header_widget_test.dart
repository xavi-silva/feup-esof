import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:sweepspot/view/widget/events/event_header_widget.dart';

void main() {
  group('EventHeader Widget Tests', () {
    const testName = 'Community Cleanup';
    const testDate = '2024-05-22';
    const testStartTime = '10:00 AM';
    const testDescription = 'Join us for a community cleanup event!';
    const testParticipantsCount = 10;
    const testCapacity = '50';
    const testIsParticipant = true;

    Widget createWidgetUnderTest({
      required String name,
      required String date,
      required String startTime,
      required String description,
      required int participantsCount,
      required String capacity,
      required bool isParticipant,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: EventHeader(
            name: name,
            date: date,
            startTime: startTime,
            description: description,
            participantsCount: participantsCount,
            capacity: capacity,
            isParticipant: isParticipant,
          ),
        ),
      );
    }

    testWidgets('displays event details correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        name: testName,
        date: testDate,
        startTime: testStartTime,
        description: testDescription,
        participantsCount: testParticipantsCount,
        capacity: testCapacity,
        isParticipant: testIsParticipant,
      ));

      expect(find.text(testName), findsOneWidget);
      expect(find.text(testDate), findsOneWidget);
      expect(find.text(testStartTime), findsOneWidget);
      expect(find.text(testDescription), findsOneWidget);
      expect(find.text('$testParticipantsCount/$testCapacity'), findsOneWidget);
    });

    testWidgets('displays "Joined" when user is a participant',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        name: testName,
        date: testDate,
        startTime: testStartTime,
        description: testDescription,
        participantsCount: testParticipantsCount,
        capacity: testCapacity,
        isParticipant: testIsParticipant,
      ));

      expect(find.text('Joined'), findsOneWidget);
    });

    testWidgets('does not display "Joined" when user is not a participant',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        name: testName,
        date: testDate,
        startTime: testStartTime,
        description: testDescription,
        participantsCount: testParticipantsCount,
        capacity: testCapacity,
        isParticipant: false,
      ));

      expect(find.text('Joined'), findsNothing);
    });

    testWidgets('renders the layout elements correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        name: testName,
        date: testDate,
        startTime: testStartTime,
        description: testDescription,
        participantsCount: testParticipantsCount,
        capacity: testCapacity,
        isParticipant: testIsParticipant,
      ));

      // Verify the expected structure of the widget tree
      final containerFinder = find.byType(Container);
      final rowFinder = find.byType(Row);
      final autoSizeTextFinder = find.byType(AutoSizeText);
      final textFinder = find.byType(Text);
      final iconFinder = find.byType(Icon);

      expect(containerFinder, findsNWidgets(3));
      expect(rowFinder, findsNWidgets(2));
      expect(autoSizeTextFinder, findsOneWidget);
      expect(textFinder, findsWidgets);
      expect(iconFinder, findsNWidgets(4));

      final paddingFinder = find.byWidgetPredicate(
        (widget) => widget is Padding && widget.padding == EdgeInsets.all(10.0),
      );
      expect(paddingFinder, findsNWidgets(2));

      final specificPaddingFinder = find.byWidgetPredicate(
        (widget) =>
            widget is Padding &&
            widget.padding == EdgeInsets.fromLTRB(10, 10, 10, 0),
      );
      expect(specificPaddingFinder, findsOneWidget);
    });
  });
}
