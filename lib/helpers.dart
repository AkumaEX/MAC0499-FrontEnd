import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:e_roubo/dialogs.dart';

SpinKitCubeGrid showCubeGrid() {
  return SpinKitCubeGrid(
    duration: Duration(seconds: 3),
    color: Colors.white,
  );
}

SpinKitRipple showRipple() {
  return SpinKitRipple(
    duration: Duration(seconds: 3),
    size: 500,
    color: Colors.white,
  );
}

SpinKitDualRing showDualRing() {
  return SpinKitDualRing(
    duration: Duration(seconds: 3),
    lineWidth: 3,
    color: Colors.blue,
  );
}

Stack showLoadingScreen() {
  double fontSize = 20;
  return Stack(
    children: [
      Container(color: Colors.black87),
      Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text('eRoubo',
                  style:
                      GoogleFonts.righteous(fontSize: 80, color: Colors.white)),
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text('Evite o Roubo de seu Celular',
                  style: GoogleFonts.righteous(
                      fontSize: fontSize, color: Colors.white)),
            ),
            SizedBox(
              height: 100,
            ),
            showCubeGrid(),
          ],
        ),
      )
    ],
  );
}

Circle newCircle(BuildContext context, String date, String time,
    double latitude, double longitude) {
  return Circle(
    circleId: CircleId('$latitude$longitude'),
    center: LatLng(latitude, longitude),
    radius: 30,
    strokeWidth: 3,
    strokeColor: Colors.red,
    fillColor: Colors.black.withOpacity(getOpacityFromTime(time)),
    consumeTapEvents: true,
    onTap: () =>
        showDialog(context: context, child: CircleInfo(date: date, time: time)),
  );
}

double getOpacityFromTime(String time) {
  try {
    List hourMinute = time.split(':');
    int hour = int.parse(hourMinute[0]);
    int minute = int.parse(hourMinute[1]);
    return 1 - (getTimeDiffFromNow(hour, minute).inMinutes / 720);
  } catch (e) {
    return 0.5;
  }
}

Duration getTimeDiffFromNow(hour, minute) {
  DateTime now = DateTime.now();
  DateTime other =
      DateTime(now.year, now.month, now.day, hour, minute, now.second);
  if (now.isAfter(other)) {
    Duration diff = now.difference(other);
    if (diff.inHours < 12) {
      return diff;
    } else {
      other = other.add(Duration(days: 1));
      return other.difference(now);
    }
  } else {
    Duration diff = other.difference(now);
    if (diff.inHours < 12) {
      return diff;
    } else {
      other = other.subtract(Duration(days: 1));
      return now.difference(other);
    }
  }
}

void moveCameraTo(LatLng target, GoogleMapController controller) {
  if (controller != null)
    controller.animateCamera(CameraUpdate.newLatLng(target));
}
