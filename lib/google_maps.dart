import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:e_roubo/helpers.dart';

class GoogleMaps extends StatefulWidget {
  @override
  _GoogleMapsState createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {
  double defaultZoom = 15;
  double iconSize = 40;
  String endPoint = 'http://104.155.175.253/ml/api';
  Set<Circle> circles = Set<Circle>();
  Future<LatLng> location;
  StreamSubscription<Position> positionStream;
  Map clusterData;
  LatLng coordinates;
  GoogleMapController mapController;

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
    getClusterData(endPoint, coordinates).then((value) {
      setState(() {
        value['geo'].forEach((info) {
          circles.add(newCircle(info[0], info[1], info[2], info[3]));
        });
      });

      checkDistance(coordinates, circles).then((isNear) {
        if (value['hotspot'] == true || isNear == true) {
          Scaffold.of(context).hideCurrentSnackBar();
          Scaffold.of(context).showSnackBar(snackBar(value['hotspot'], isNear));
        } else {
          Scaffold.of(context).hideCurrentSnackBar();
        }
      });
    });
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
