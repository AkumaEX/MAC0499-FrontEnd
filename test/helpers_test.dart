import 'package:flutter/material.dart';
import 'package:test/test.dart';
import 'package:e_roubo/helpers.dart';
import 'package:flutter_test/flutter_test.dart' as flutter_test;
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  flutter_test.TestWidgetsFlutterBinding.ensureInitialized();

  test('Show loading screen', () {
    var loadingScreen = showLoadingScreen();
    expect(loadingScreen, isA<Stack>());
  });

  test('Time diff from now', () {
    DateTime now = DateTime.now();
    DateTime p2hours = now.add(Duration(hours: 23));
    DateTime m2hours = now.subtract(Duration(hours: 23));
    Duration diffp2hours = getTimeDiffFromNow(p2hours.hour, 0);
    Duration diffm2hours = getTimeDiffFromNow(m2hours.hour, 0);
    expect(diffp2hours.inHours, lessThanOrEqualTo(Duration(hours: 23).inHours));
    expect(diffm2hours.inHours, lessThanOrEqualTo(Duration(hours: 23).inHours));
  });

  test('Opacity from time', () {
    List times = ['00:00', '06:15', '12:30', '18:45', '24:00'];
    for (String time in times) {
      double opacity = getOpacityFromTime(time);
      expect(opacity, lessThanOrEqualTo(1));
      expect(opacity, greaterThanOrEqualTo(0));
    }
  });

  test('Opacity from invalid time', () {
    double invalid = getOpacityFromTime('invalid time');
    expect(invalid, 0.5);
  });

  flutter_test.testWidgets('Create new Circle',
      (flutter_test.WidgetTester tester) async {
    await tester.pumpWidget(Builder(
      builder: (BuildContext context) {
        var circle = newCircle(context, '21/01/2018', '09:00',
            -23.5598559640699, -46.7401591295266);
        expect(circle, isA<Circle>());
        expect(circle.circleId, CircleId('-23.5598559640699-46.7401591295266'));
        expect(circle.center, LatLng(-23.5598559640699, -46.7401591295266));
        expect(circle.strokeWidth, 3);
        expect(circle.strokeColor, Colors.red);
        expect(circle.fillColor,
            Colors.black54.withOpacity(getOpacityFromTime('09:00')));
        expect(circle.consumeTapEvents, true);
        return Container();
      },
    ));
  });
}
