import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:e_roubo/snackbar_tile.dart';

void main() {
  group('null Hostpot', () {
    setUp(WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SnackBarTile(isHotspot: null, isNear: true),
        ),
      ));
    }

    testWidgets('Collapsed Tile', (WidgetTester tester) async {
      await setUp(tester);
      Finder iconFinder = find.byIcon(Icons.sync_problem);
      Finder titleFinder = find.text('Sem conexão');
      expect(iconFinder, findsOneWidget);
      expect(titleFinder, findsOneWidget);
      Icon icon = tester.widget(iconFinder);
      expect(icon.color, Colors.blue);
    });

    testWidgets('Expanded Tile', (WidgetTester tester) async {
      await setUp(tester);
      await tester.tap(find.byType(Text));
      await tester.pump();
      Finder iconFinder = find.byIcon(Icons.signal_cellular_off);
      Finder textFinder = find.text(
          'Verifique a sua conexão com a Internet. Se o problema persistir, tente novamente mais tarde');
      expect(iconFinder, findsOneWidget);
      expect(textFinder, findsOneWidget);
      Icon icon = tester.widget(iconFinder);
      expect(icon.color, Colors.blue);
    });
  });

  group('Hostpot and is near', () {
    setUp(WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SnackBarTile(isHotspot: true, isNear: true),
        ),
      ));
    }

    testWidgets('Collapsed Tile', (WidgetTester tester) async {
      await setUp(tester);
      Finder iconFinder = find.byIcon(Icons.pan_tool);
      Finder titleFinder = find.text('Evite o uso neste local');
      expect(iconFinder, findsOneWidget);
      expect(titleFinder, findsOneWidget);
      Icon icon = tester.widget(iconFinder);
      expect(icon.color, Colors.red);
    });

    testWidgets('Expanded Tile (Hotspot)', (WidgetTester tester) async {
      await setUp(tester);
      await tester.tap(find.byType(Text));
      await tester.pump();
      Finder iconFinder = find.byIcon(Icons.trending_up);
      Finder textFinder =
          find.text('Previsão de alto número de roubos nesta região');
      expect(iconFinder, findsOneWidget);
      expect(textFinder, findsOneWidget);
      Icon icon = tester.widget(iconFinder);
      expect(icon.color, Colors.red);
    });

    testWidgets('Expanded Tile (isNear)', (WidgetTester tester) async {
      await setUp(tester);
      await tester.tap(find.byType(Text));
      await tester.pump();
      Finder iconFinder = find.byIcon(Icons.track_changes);
      Finder textFinder = find.text('Próximo de um local de roubo');
      expect(iconFinder, findsOneWidget);
      expect(textFinder, findsOneWidget);
      Icon icon = tester.widget(iconFinder);
      expect(icon.color, Colors.red);
    });
  });

  group('Hotspot and not is near', () {
    setUp(WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SnackBarTile(isHotspot: true, isNear: false),
        ),
      ));
    }

    testWidgets('Collapsed Tile', (WidgetTester tester) async {
      await setUp(tester);
      Finder iconFinder = find.byIcon(Icons.warning);
      Finder textFinder = find.text('Região potencialmente perigoso');
      expect(iconFinder, findsOneWidget);
      expect(textFinder, findsOneWidget);
      Icon icon = tester.widget(iconFinder);
      expect(icon.color, Colors.yellow);
    });

    testWidgets('Expanded Tile (Hotspot)', (WidgetTester tester) async {
      await setUp(tester);
      await tester.tap(find.byType(Text));
      await tester.pump();
      Finder iconFinder = find.byIcon(Icons.trending_up);
      Finder textFinder =
          find.text('Previsão de alto número de roubos nesta região');
      expect(iconFinder, findsOneWidget);
      expect(textFinder, findsOneWidget);
      Icon icon = tester.widget(iconFinder);
      expect(icon.color, Colors.red);
    });

    testWidgets('Expanded Tile (isNear)', (WidgetTester tester) async {
      await setUp(tester);
      await tester.tap(find.byType(Text));
      await tester.pump();
      Finder iconFinder = find.byIcon(Icons.track_changes);
      Finder textFinder = find.text('Longe de um local de roubo');
      expect(iconFinder, findsOneWidget);
      expect(textFinder, findsOneWidget);
      Icon icon = tester.widget(iconFinder);
      expect(icon.color, Colors.green);
    });
  });

  group('not Hotspot and is near', () {
    setUp(WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SnackBarTile(isHotspot: false, isNear: true),
        ),
      ));
    }

    testWidgets('Collapsed Tile', (WidgetTester tester) async {
      await setUp(tester);
      Finder iconFinder = find.byIcon(Icons.warning);
      Finder textFinder = find.text('Região de roubo anterior');
      expect(iconFinder, findsOneWidget);
      expect(textFinder, findsOneWidget);
      Icon icon = tester.widget(iconFinder);
      expect(icon.color, Colors.yellow);
    });

    testWidgets('Expanded Tile (Hotspot)', (WidgetTester tester) async {
      await setUp(tester);
      await tester.tap(find.byType(Text));
      await tester.pump();
      Finder iconFinder = find.byIcon(Icons.trending_down);
      Finder textFinder =
          find.text('Previsão de baixo número de roubos nesta região');
      expect(iconFinder, findsOneWidget);
      expect(textFinder, findsOneWidget);
      Icon icon = tester.widget(iconFinder);
      expect(icon.color, Colors.green);
    });

    testWidgets('Expanded Tile (isNear)', (WidgetTester tester) async {
      await setUp(tester);
      await tester.tap(find.byType(Text));
      await tester.pump();
      Finder iconFinder = find.byIcon(Icons.track_changes);
      Finder textFinder = find.text('Próximo de um local de roubo');
      expect(iconFinder, findsOneWidget);
      expect(textFinder, findsOneWidget);
      Icon icon = tester.widget(iconFinder);
      expect(icon.color, Colors.red);
    });
  });

  group('not Hotspot and not is near', () {
    setUp(WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SnackBarTile(isHotspot: false, isNear: false),
        ),
      ));
    }

    testWidgets('Collapsed Tile', (WidgetTester tester) async {
      await setUp(tester);
      Finder iconFinder = find.byIcon(Icons.check_circle);
      Finder textFinder = find.text('Aparentemente seguro');
      expect(iconFinder, findsOneWidget);
      expect(textFinder, findsOneWidget);
      Icon icon = tester.widget(iconFinder);
      expect(icon.color, Colors.green);
    });

    testWidgets('Expanded Tile (Hotspot)', (WidgetTester tester) async {
      await setUp(tester);
      await tester.tap(find.byType(Text));
      await tester.pump();
      Finder iconFinder = find.byIcon(Icons.trending_down);
      Finder textFinder =
          find.text('Previsão de baixo número de roubos nesta região');
      expect(iconFinder, findsOneWidget);
      expect(textFinder, findsOneWidget);
      Icon icon = tester.widget(iconFinder);
      expect(icon.color, Colors.green);
    });

    testWidgets('Expanded Tile (isNear)', (WidgetTester tester) async {
      await setUp(tester);
      await tester.tap(find.byType(Text));
      await tester.pump();
      Finder iconFinder = find.byIcon(Icons.track_changes);
      Finder textFinder = find.text('Longe de um local de roubo');
      expect(iconFinder, findsOneWidget);
      expect(textFinder, findsOneWidget);
      Icon icon = tester.widget(iconFinder);
      expect(icon.color, Colors.green);
    });
  });
}
