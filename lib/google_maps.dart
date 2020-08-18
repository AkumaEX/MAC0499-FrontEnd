import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMaps extends StatefulWidget {
  @override
  _GoogleMapsState createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {
  double defaultZoom = 15;
  double fontSize = 20;
  double iconSize = 40;
  double edgeSize = 10;
  double opacity = 0.5;
  double distRadius = 300;
  double circleRadius = 30;
  String domain = 'http://104.155.175.253/ml/api';
  Set<Circle> circles = Set<Circle>();
  Future<LatLng> location;
  StreamSubscription<Position> positionStream;
  Map clusterData;
  LatLng coordinates;
  GoogleMapController mapController;

  Future<LatLng> getLocation() async {
    Position position = await Geolocator().getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    return LatLng(position.latitude, position.longitude);
  }

  StreamSubscription<Position> startTracking() {
    if (positionStream != null) {
      positionStream.cancel();
    }
    var locationOptions = LocationOptions(
        accuracy: LocationAccuracy.bestForNavigation, distanceFilter: 10);
    return Geolocator()
        .getPositionStream(locationOptions)
        .listen((Position position) {
      coordinates = LatLng(position.latitude, position.longitude);
      mapController.moveCamera(CameraUpdate.newLatLng(coordinates));
    });
  }

  Future showInfo(BuildContext context, LatLng coordinates) async {
    _getClusterData(coordinates).then((value) {
      setState(() {
        value['geo'].forEach((info) {
          circles.add(_circle(info[0], info[1], info[2], info[3]));
        });
      });

      _checkDistance(coordinates, circles).then((isNear) {
        if (value['hotspot'] == true || isNear == true) {
          Scaffold.of(context).hideCurrentSnackBar();
          Scaffold.of(context)
              .showSnackBar(_snackBar(value['hotspot'], isNear));
        } else {
          Scaffold.of(context).hideCurrentSnackBar();
        }
      });
    });
  }

  Future<Map> _getClusterData(LatLng location) async {
    var url =
        '$domain?latitude=${location.latitude}&longitude=${location.longitude}';
    http.Response response = await http.get(url);
    return json.decode(response.body);
  }

  Circle _circle(String date, String time, double latitude, double longitude) {
    return Circle(
      circleId: CircleId('$latitude$longitude'),
      center: LatLng(latitude, longitude),
      radius: circleRadius,
      strokeWidth: 2,
      strokeColor: Colors.red,
      fillColor: Colors.redAccent.withOpacity(opacity),
      consumeTapEvents: true,
      onTap: () {
        showDialog(context: context, child: _showDialog(date, time));
      },
    );
  }

  Dialog _showDialog(String date, String time) {
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

  Future<bool> _checkDistance(LatLng coordinates, Set<Circle> circles) async {
    for (Circle circle in circles) {
      double distance = await Geolocator().distanceBetween(
          coordinates.latitude,
          coordinates.longitude,
          circle.center.latitude,
          circle.center.longitude);
      if (distance < distRadius) {
        return true;
      }
    }
    return false;
  }

  SnackBar _snackBar(bool isHotspot, bool isNear) {
    return SnackBar(
      padding: EdgeInsets.all(edgeSize),
      content: Row(
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
                ? 'Área de risco e próximo ao um local de crime'
                : (isHotspot == true)
                    ? 'Está em uma área de risco'
                    : 'Está próximo a um local de crime',
            style: TextStyle(fontSize: fontSize),
            textAlign: TextAlign.center,
          ))
        ],
      ),
      duration: Duration(days: 30),
    );
  }

  @override
  void initState() {
    location = getLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: location,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              );
            default:
              coordinates = snapshot.data;
          }
          return Stack(children: <Widget>[
            GoogleMap(
                zoomControlsEnabled: false,
                initialCameraPosition:
                    CameraPosition(target: coordinates, zoom: defaultZoom),
                onMapCreated: (controller) => mapController = controller,
                onCameraMoveStarted: () {
                  if (positionStream != null) {
                    positionStream.cancel();
                  }
                },
                onCameraMove: (position) => coordinates = position.target,
                onCameraIdle: () => showInfo(context, coordinates),
                circles: circles),
            Align(
                child: Icon(Icons.place, size: iconSize, color: Colors.blue),
                alignment: Alignment.center),
          ]);
        },
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.my_location),
          onPressed: () => positionStream = startTracking()),
    );
  }
}
