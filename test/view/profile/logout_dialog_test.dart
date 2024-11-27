import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:sweepspot/view/widget/profile/logout_dialog.dart';

class MockCallback extends Mock {
  void call();
}

void main() {
  group('LogoutDialog Widget Tests', () {
    late MockCallback mockOnConfirm;

    setUp(() {
      mockOnConfirm = MockCallback();
    });

    testWidgets('displays the correct title and content',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return LogoutDialog();
                      },
                    );
                  },
                  child: Text('Show Dialog'),
                );
              },
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Confirm Logout'), findsOneWidget);
      expect(find.text('Are you sure you want to log out?'), findsOneWidget);
    });

    testWidgets('Cancel button closes the dialog', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return LogoutDialog();
                      },
                    );
                  },
                  child: Text('Show Dialog'),
                );
              },
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(AlertDialog), findsNothing);
    });
  });
}
