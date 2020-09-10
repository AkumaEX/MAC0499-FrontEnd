import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:e_roubo/dialogs.dart';

void main() {
  group('CircleInfo test', () {
    setUp(WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: CircleInfo(date: '01/01/2020', time: '00:00'),
        ),
      ));
    }

    testWidgets('Find SimpleDialog', (WidgetTester tester) async {
      await setUp(tester);
      Finder dialogFinder = find.byType(SimpleDialog);
      expect(dialogFinder, findsOneWidget);
      SimpleDialog simpleDialog = tester.widget(dialogFinder);
      Text title = simpleDialog.title;
      expect(title.data, 'Informação do Roubo');
    });

    testWidgets('Find Two ListTiles', (WidgetTester tester) async {
      await setUp(tester);
      Finder listTileFinder = find.byType(ListTile);
      expect(listTileFinder, findsNWidgets(2));
    });

    testWidgets('Test Date Information', (WidgetTester tester) async {
      await setUp(tester);
      Finder dateFinder = find.byKey(Key('circle_info_date'));
      ListTile dateTile = tester.widget(dateFinder);
      Icon icon = dateTile.leading;
      Text title = dateTile.title;
      Text subtitle = dateTile.subtitle;
      expect(icon.icon, Icons.event);
      expect(title.data, 'Data');
      expect(subtitle.data, '01/01/2020');
    });

    testWidgets('Test Time Information', (WidgetTester tester) async {
      await setUp(tester);
      Finder dateFinder = find.byKey(Key('circle_info_time'));
      ListTile dateTile = tester.widget(dateFinder);
      Icon icon = dateTile.leading;
      Text title = dateTile.title;
      Text subtitle = dateTile.subtitle;
      expect(icon.icon, Icons.schedule);
      expect(title.data, 'Horário');
      expect(subtitle.data, '00:00');
    });
  });

  group('SearchDialog test', () {
    setUp(WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SearchDialog(),
        ),
      ));
    }

    testWidgets('Find SimpleDialog', (WidgetTester tester) async {
      await setUp(tester);
      Finder dialogFinder = find.byType(SimpleDialog);
      expect(dialogFinder, findsOneWidget);
      SimpleDialog dialog = tester.widget(dialogFinder);
      Text title = dialog.title;
      expect(title.data, 'Busca');
    });

    testWidgets('Find TextField', (WidgetTester tester) async {
      await setUp(tester);
      Finder textFieldFinder = find.byType(TextField);
      expect(textFieldFinder, findsOneWidget);
    });
  });

  group('Instructions test', () {
    setUp(WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Instructions(),
        ),
      ));
    }

    testWidgets('Find AlertDialog', (WidgetTester tester) async {
      await setUp(tester);
      Finder dialog = find.byType(AlertDialog);
      expect(dialog, findsOneWidget);
    });

    testWidgets('Find 13 ListTiles', (WidgetTester tester) async {
      await setUp(tester);
      Finder listTiles = find.byType(ListTile);
      expect(listTiles, findsNWidgets(13));
    });

    testWidgets('Find FlatButton', (WidgetTester tester) async {
      await setUp(tester);
      Finder flatButton = find.byType(FlatButton);
      expect(flatButton, findsOneWidget);
    });
  });
}
