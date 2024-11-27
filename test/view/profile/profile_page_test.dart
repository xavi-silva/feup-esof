import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:sweepspot/control/data_controller.dart';
import 'package:sweepspot/view/pages/profile/profile_page.dart';

class MockDataController extends Mock implements DataController {}

void main() {
  late MockDataController mockDataController;
  setUp(() {
    mockDataController = MockDataController();
  });

  Future<void> pumpProfilePage(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ProfilePage(dataController: mockDataController),
      ),
    );
  }

  testWidgets('renders ProfilePage and fetches data on init',
      (WidgetTester tester) async {
    when(mockDataController.getUserInfo()).thenAnswer((_) async {});
    when(mockDataController.getUserEvents()).thenAnswer((_) async {});

    await pumpProfilePage(tester);

    verify(mockDataController.getUserInfo()).called(1);
    verify(mockDataController.getUserEvents()).called(1);
  });
}
