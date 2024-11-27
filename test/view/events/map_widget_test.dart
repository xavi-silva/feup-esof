import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sweepspot/view/widget/events/map_widget.dart';

void main() {
  testWidgets('MapWidget adds marker from initial GeoPoint',
      (WidgetTester tester) async {
    final GeoPoint initialGeoPoint = GeoPoint(40.7128, -74.0060);
    final mapWidget = MapWidget(initialGeoPoint: initialGeoPoint);
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: mapWidget)));
    expect(mapWidget.markers.length, 1);
    expect(mapWidget.getMarkerCoordinates(),
        LatLng(initialGeoPoint.latitude, initialGeoPoint.longitude));
  });
}
