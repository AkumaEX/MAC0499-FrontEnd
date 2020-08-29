import 'package:flutter/material.dart';
import 'package:test/test.dart';
import 'package:e_roubo/helpers.dart';
import 'package:flutter_test/flutter_test.dart' as flutter_test;

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
}
