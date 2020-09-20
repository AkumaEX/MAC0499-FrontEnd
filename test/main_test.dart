import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:e_roubo/main.dart';

void main() {
  testWidgets('Show Loading Screen', (WidgetTester tester) async {
    await tester.pumpWidget(ERoubo());
    expect(find.byKey(Key('loading_screen')), findsOneWidget);
    expect(find.text('eRoubo'), findsOneWidget);
    expect(find.text('Evite o Roubo de seu Celular'), findsOneWidget);
  });
}
