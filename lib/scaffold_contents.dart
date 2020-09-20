import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:e_roubo/geolocator_contents.dart';
import 'package:e_roubo/helpers.dart';
import 'package:e_roubo/dialogs.dart';
import 'package:e_roubo/snackbar_tile.dart';

AppBar showAppBar(BuildContext context, GoogleMapController controller) {
  Color bgColor = Colors.black54.withOpacity(0.5);
  double fontSize = 20;
  return AppBar(
    title: Text('eRoubo', style: GoogleFonts.righteous(fontSize: fontSize)),
    centerTitle: true,
    backgroundColor: bgColor,
    actions: [
      IconButton(
        icon: Icon(Icons.search),
        onPressed: () => showDialog(context: context, child: SearchDialog(controller: controller)),
      ),
      IconButton(
        icon: Icon(Icons.help_outline),
        onPressed: () => showDialog(context: context, child: Instructions()),
      )
    ],
  );
}

Future<Map> getFeatureCollection(LatLng location) async {
  try {
    var queryParams = {
      'latitude': location.latitude.toString(),
      'longitude': location.longitude.toString(),
    };
    var url = Uri.http('34.71.127.108', '/ml/api', queryParams);
    var response = await http.get(url);
    return json.decode(response.body);
  } catch (e) {
    return Map();
  }
}

Future getInfo(BuildContext context, LatLng coordinates, Set<Circle> circles, Set<Polygon> polygons) async {
  Map collection = await getFeatureCollection(coordinates);
  if (collection.isNotEmpty) {
    Set<Circle> newCircles = Set<Circle>();
    Set<Polygon> newPolygons = Set<Polygon>();
    for (Map feature in collection['features']) {
      if (feature['geometry']['type'] == 'Point') {
        String date = feature['properties']['date'];
        String time = feature['properties']['time'];
        double latitude = feature['geometry']['coordinates'][0];
        double longitude = feature['geometry']['coordinates'][1];
        newCircles.add(newCircle(context, date, time, latitude, longitude));
      } else if (feature['geometry']['type'] == 'LineString') {
        newPolygons.add(newPolygon(feature['geometry']['coordinates'], feature['cluster'], feature['hotspot']));
      }
    }
    circles.addAll(newCircles);
    polygons.addAll(newPolygons);
    return collection['hotspot'];
  }
  return null;
}

void showSnackBar(BuildContext context, LatLng coordinates, Set<Circle> circles, isHotspot) async {
  Scaffold.of(context).hideCurrentSnackBar();
  bool isNear = await checkDistance(coordinates, circles);
  SnackBar newSnackBar = getSnackBar(isHotspot, isNear);
  Scaffold.of(context).showSnackBar(newSnackBar);
}

SnackBar getSnackBar(bool isHotspot, bool isNear) {
  return SnackBar(
    backgroundColor: Colors.black54.withOpacity(0.5),
    duration: Duration(days: 30),
    content: SnackBarTile(isHotspot: isHotspot, isNear: isNear),
  );
}
