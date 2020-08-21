import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:e_roubo/main.dart';
import 'package:e_roubo/google_maps.dart';

void main() {
  testWidgets('Floating Action Button', (WidgetTester tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(MyApp());
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.my_location), findsOneWidget);
    });
  });

  testWidgets('Google Maps', (WidgetTester tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(MyApp());
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(GoogleMaps), findsOneWidget);
    });
  });
}
