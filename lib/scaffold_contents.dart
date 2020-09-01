import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:e_roubo/geolocator_contents.dart';
import 'package:e_roubo/helpers.dart';
import 'package:e_roubo/dialogs.dart';
import 'package:e_roubo/text_helpers.dart';

double fontSize = 20;
Color bgColor = Colors.black54.withOpacity(0.5);
String endPoint = 'http://104.155.175.253/ml/api';

AppBar showAppBar(BuildContext context, GoogleMapController controller) {
  return AppBar(
    title: Text('eRoubo', style: GoogleFonts.righteous(fontSize: fontSize)),
    centerTitle: true,
    backgroundColor: bgColor,
    actions: [
      IconButton(
        icon: Icon(Icons.search),
        onPressed: () => showSearchDialog(context, controller),
      ),
      IconButton(
        icon: Icon(Icons.more_vert),
        onPressed: () => showPopupMenu(context),
      )
    ],
  );
}

FloatingActionButton showFloatingActionButton(StreamSubscription positionStream,
    LatLng coordinates, GoogleMapController controller) {
  return FloatingActionButton(
      child: Icon(Icons.my_location),
      backgroundColor: bgColor,
      onPressed: () {
        positionStream.cancel();
        positionStream = startTracking(coordinates, controller);
      });
}

Future<Map> getClusterData(LatLng location) async {
  try {
    String url =
        '$endPoint?latitude=${location.latitude}&longitude=${location.longitude}';
    http.Response response = await http.get(url);
    return json.decode(response.body);
  } catch (e) {
    return Map();
  }
}

Future getInfo(
    BuildContext context, LatLng coordinates, Set<Circle> circles) async {
  Map data = await getClusterData(coordinates);
  if (data.isNotEmpty) {
    data['geo'].forEach((info) {
      circles.add(newCircle(context, info[0], info[1], info[2], info[3]));
    });
    return data['hotspot'];
  }
  return null;
}

void showSnackBar(BuildContext context, LatLng coordinates, Set<Circle> circles,
    isHotspot) async {
  bool isNear = await checkDistance(coordinates, circles);
  Scaffold.of(context).hideCurrentSnackBar();
  if (isHotspot == null || isHotspot || isNear) {
    Scaffold.of(context).showSnackBar(snackBar(isHotspot, isNear));
  }
}

SnackBar snackBar(bool isHotspot, bool isNear) {
  double iconSize = 40;
  return SnackBar(
      backgroundColor: bgColor,
      duration: Duration(days: 30),
      content: (isHotspot == null)
          ? IconTextV(icons: [
              Icon(Icons.sync_problem, color: Colors.blue, size: iconSize)
            ], text: 'Servidor fora do ar. Tente novamente mais tarde')
          : (isHotspot && isNear)
              ? IconTextV(icons: [
                  Icon(Icons.warning, color: Colors.red, size: iconSize)
                ], text: 'Área de risco e próximo a um local de crime')
              : (isHotspot)
                  ? IconTextV(icons: [
                      Icon(Icons.warning, color: Colors.yellow, size: iconSize)
                    ], text: 'Área de risco')
                  : IconTextV(icons: [
                      Icon(Icons.warning, color: Colors.yellow, size: iconSize)
                    ], text: 'Próximo a um local de crime'));
}
