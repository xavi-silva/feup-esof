import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sweepspot/view/widget/profile/notification_button.dart';
import 'package:sweepspot/view/widget/profile/profile_app_bar.dart';

void main() {
  testWidgets('ProfileAppBar displays correctly', (WidgetTester tester) async {
    // Arrange
    final onLogout = () {};
    final onEditProfile = () {};
    final onNotification = () {};

    // Act
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        appBar: ProfileAppBar(
          onLogout: onLogout,
          onEditProfile: onEditProfile,
          onNotification: onNotification,
        ),
      ),
    ));

    // Assert
    expect(find.byIcon(Icons.logout), findsOneWidget);
    expect(find.byType(NotificationButton), findsOneWidget);
    expect(find.byIcon(Icons.edit), findsOneWidget);
  });

  testWidgets('ProfileAppBar onLogout callback is triggered',
      (WidgetTester tester) async {
    // Arrange
    var logoutCalled = false;
    final onLogout = () {
      logoutCalled = true;
    };
    final onEditProfile = () {};
    final onNotification = () {};

    // Act
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        appBar: ProfileAppBar(
          onLogout: onLogout,
          onEditProfile: onEditProfile,
          onNotification: onNotification,
        ),
      ),
    ));

    // Act
    await tester.tap(find.byIcon(Icons.logout));
    await tester.pump();

    // Assert
    expect(logoutCalled, isTrue);
  });

  testWidgets('ProfileAppBar onEditProfile callback is triggered',
      (WidgetTester tester) async {
    // Arrange
    var editProfileCalled = false;
    final onLogout = () {};
    final onEditProfile = () {
      editProfileCalled = true;
    };
    final onNotification = () {};

    // Act
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        appBar: ProfileAppBar(
          onLogout: onLogout,
          onEditProfile: onEditProfile,
          onNotification: onNotification,
        ),
      ),
    ));

    // Act
    await tester.tap(find.byIcon(Icons.edit));
    await tester.pump();

    // Assert
    expect(editProfileCalled, isTrue);
  });

  testWidgets('ProfileAppBar onNotification callback is present',
      (WidgetTester tester) async {
    // Arrange
    final onLogout = () {};
    final onEditProfile = () {};
    final onNotification = () {};

    // Act
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        appBar: ProfileAppBar(
          onLogout: onLogout,
          onEditProfile: onEditProfile,
          onNotification: onNotification,
        ),
      ),
    ));

    // Assert
    expect(find.byType(NotificationButton), findsOneWidget);
  });
}
