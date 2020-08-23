import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mockito/mockito.dart';
import 'package:e_roubo/google_maps.dart';

class MockGeolocator extends Mock implements Geolocator {}

Geolocator mockGeolocator;

Position get mockPosition => Position(
    latitude: -23.5489,
    longitude: -46.6388,
    timestamp: DateTime.fromMillisecondsSinceEpoch(
      500,
      isUtc: true,
    ),
    altitude: 3000.0,
    accuracy: 0.0,
    heading: 0.0,
    speed: 0.0,
    speedAccuracy: 0.0);

void main() {
  group('Test Main Screen', () {
    setUp(() {
      mockGeolocator = MockGeolocator();
      when(mockGeolocator.isLocationServiceEnabled())
          .thenAnswer((_) => Future.value(true));
      when(mockGeolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.bestForNavigation))
          .thenAnswer((_) => Future.value(mockPosition));
    });

    Future<void> _createWidget(WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        title: 'eRoubo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: GoogleMaps(mockGeolocator),
      ));
      await tester.pump();
    }

    testWidgets('Loading Screen', (WidgetTester tester) async {
      await _createWidget(tester);
      expect(find.byKey(Key('loading')), findsOneWidget);
    });

    testWidgets('Show Map', (WidgetTester tester) async {
      await _createWidget(tester);
      expect(find.byKey(Key('google_map')), findsOneWidget);
    });

    testWidgets('Show Place Icon', (WidgetTester tester) async {
      await _createWidget(tester);
      expect(find.byKey(Key('place_icon')), findsOneWidget);
    });
  });
}
