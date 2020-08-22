import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

double fontSize = 20;
double edgeSize = 10;
double distRadius = 300;
double iconSize = 40;
double opacity = 0.5;

Stack showLoadingScreen() {
  return Stack(
    key: Key('loading'),
    children: [
      Container(
        color: Colors.black87,
      ),
      Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text('eRoubo',
                  style: GoogleFonts.righteous(
                      fontSize: 100, color: Colors.white)),
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text('Evite o Roubo de seu Celular',
                  style: GoogleFonts.righteous(
                      fontSize: fontSize, color: Colors.white)),
            ),
            Padding(
              padding: EdgeInsets.only(top: 100),
              child: CircularProgressIndicator(),
            )
          ],
        ),
      )
    ],
  );
}

AppBar showAppBar() {
  return AppBar(
    title: Text('eRoubo', style: GoogleFonts.righteous()),
    centerTitle: true,
    backgroundColor: Colors.black54.withOpacity(opacity),
  );
}

Future<LatLng> getLocation() async {
  Position position = await Geolocator()
      .getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
  return LatLng(position.latitude, position.longitude);
}

Future<Map> getClusterData(String endPoint, LatLng location) async {
  var url =
      '$endPoint?latitude=${location.latitude}&longitude=${location.longitude}';
  http.Response response = await http.get(url);
  return json.decode(response.body);
}

Circle newCircle(BuildContext context, String date, String time,
    double latitude, double longitude) {
  return Circle(
    circleId: CircleId('$latitude$longitude'),
    center: LatLng(latitude, longitude),
    radius: 30,
    strokeWidth: 3,
    strokeColor: Colors.red,
    fillColor: Colors.black.withOpacity(_getOpacityFromTime(time)),
    consumeTapEvents: true,
    onTap: () {
      showDialog(context: context, child: _showDateAndTimeDialog(date, time));
    },
  );
}

double _getOpacityFromTime(String time) {
  return 1 - (getTimeDiffFromNow(time).inMinutes / 1440).abs();
}

Duration getTimeDiffFromNow(time) {
  List hourMinute = time.split(':');
  DateTime now = DateTime.now();
  int hour = int.parse(hourMinute[0]);
  int minute = int.parse(hourMinute[1]);
  return now.difference(
      DateTime(now.year, now.month, now.day, hour, minute, now.second));
}

Dialog _showDateAndTimeDialog(String date, String time) {
  return Dialog(
    child: Padding(
      padding: EdgeInsets.all(edgeSize),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Informações do Roubo',
              style:
                  TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold)),
          Text('Data: $date', style: TextStyle(fontSize: fontSize)),
          Text('Horário: $time', style: TextStyle(fontSize: fontSize))
        ],
      ),
    ),
  );
}

Future<bool> checkDistance(LatLng coordinates, Set<Circle> circles) async {
  for (Circle circle in circles) {
    double distance = await Geolocator().distanceBetween(coordinates.latitude,
        coordinates.longitude, circle.center.latitude, circle.center.longitude);
    if (distance < distRadius) {
      return true;
    }
  }
  return false;
}

SnackBar snackBar(bool isHotspot, bool isNear) {
  return SnackBar(
    backgroundColor: Colors.black54,
    padding: EdgeInsets.all(edgeSize),
    duration: Duration(days: 30),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.warning,
          size: iconSize,
          color: (isHotspot == true && isNear == true)
              ? Colors.red
              : Colors.yellow,
        ),
        Flexible(
            child: Text(
          (isHotspot == true && isNear == true)
              ? 'Área de risco e próximo a um local de crime'
              : (isHotspot == true)
                  ? 'Área de risco'
                  : 'Próximo a um local de crime',
          style: TextStyle(fontSize: fontSize),
          textAlign: TextAlign.center,
        ))
      ],
    ),
  );
}
