import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sweepspot/view/widget/profile/profile_content.dart';
import 'package:network_image_mock/network_image_mock.dart';

// Create a mock class for DocumentSnapshot
class MockDocumentSnapshot extends Mock implements DocumentSnapshot {}

void main() {
  group('ProfileContent Widget Tests', () {
    testWidgets('displays profile information correctly',
        (WidgetTester tester) async {
      // Arrange
      final profile = ProfileContent(
        firstName: 'John',
        lastName: 'Doe',
        username: 'john_doe',
        image: 'https://example.com/image.jpg',
        cleanupsCount: 10,
        filteredEvents: [],
      );

      // Act
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(MaterialApp(home: Scaffold(body: profile)));
      });

      // Assert
      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('john_doe'), findsOneWidget);
      expect(find.text('10'), findsOneWidget);
      expect(find.text('clean-ups'), findsOneWidget);
      expect(find.byType(CircleAvatar), findsOneWidget);
    });

    testWidgets('displays "No past events" message when filteredEvents is null',
        (WidgetTester tester) async {
      // Arrange
      final profileWithNullEvents = ProfileContent(
        firstName: 'John',
        lastName: 'Doe',
        username: 'john_doe',
        image: 'https://example.com/image.jpg',
        cleanupsCount: 10,
        filteredEvents: null,
      );

      // Act
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
            MaterialApp(home: Scaffold(body: profileWithNullEvents)));
      });

      // Assert
      expect(find.text('No past events'), findsOneWidget);
    });

    testWidgets(
        'displays "No past events" message when filteredEvents is empty',
        (WidgetTester tester) async {
      // Arrange
      final profileWithEmptyEvents = ProfileContent(
        firstName: 'John',
        lastName: 'Doe',
        username: 'john_doe',
        image: 'https://example.com/image.jpg',
        cleanupsCount: 10,
        filteredEvents: [],
      );

      // Act
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
            MaterialApp(home: Scaffold(body: profileWithEmptyEvents)));
      });

      // Assert
      expect(find.text('No past events'), findsOneWidget);
    });
  });
}
