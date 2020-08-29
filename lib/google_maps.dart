import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:e_roubo/helpers.dart';
import 'package:e_roubo/scaffold_contents.dart';
import 'package:e_roubo/geolocator_contents.dart';

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
  Color bgColor = Colors.black54.withOpacity(0.5);
  AppBar appBar;
  FloatingActionButton floatingActionButton;

  Future showInfo(BuildContext context, LatLng coordinates) async {
    getClusterData(endPoint, coordinates).then((data) {
      setState(() {
        data['geo'].forEach((info) {
          circles.add(newCircle(context, info[0], info[1], info[2], info[3]));
        });
      });

      checkDistance(coordinates, circles).then((isNear) {
        Scaffold.of(context).hideCurrentSnackBar();
        if (data['hotspot'] || isNear) {
          Scaffold.of(context).showSnackBar(snackBar(data['hotspot'], isNear));
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
      resizeToAvoidBottomPadding: false,
      key: Key('scaffold'),
      extendBodyBehindAppBar: true,
      appBar: appBar,
      body: FutureBuilder(
        future: location,
        builder: (context, snapshot) {
          Widget child;
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              child = showLoadingScreen();
              break;
            default:
              coordinates = snapshot.data;
              child = Stack(children: <Widget>[
                GoogleMap(
                  key: Key('google_map'),
                  initialCameraPosition: CameraPosition(
                    target: coordinates,
                    zoom: defaultZoom,
                  ),
                  onMapCreated: (controller) {
                    mapController = controller;
                    positionStream = startTracking(coordinates, mapController);
                    appBar = showAppBar(context, mapController);
                    floatingActionButton = showFloatingActionButton(
                        positionStream, coordinates, mapController);
                  },
                  onCameraMoveStarted: () => positionStream.cancel(),
                  onCameraMove: (position) => coordinates = position.target,
                  onCameraIdle: () => showInfo(context, coordinates),
                  circles: circles,
                  zoomControlsEnabled: false,
                  rotateGesturesEnabled: false,
                ),
                Align(
                  key: Key('place_icon'),
                  alignment: Alignment.center,
                  child: Icon(Icons.place, size: iconSize, color: Colors.blue),
                )
              ]);
          }
          return AnimatedSwitcher(duration: Duration(seconds: 3), child: child);
        },
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
