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
  Set<Circle> circles = Set<Circle>();
  Future<LatLng> location;
  LatLng coordinates;
  StreamSubscription<Position> positionStream;
  Map clusterData;
  GoogleMapController mapController;
  Color bgColor = Colors.black54.withOpacity(0.5);
  AppBar appBar;
  FloatingActionButton floatingActionButton;
  bool isHotspot;

  @override
  void initState() {
    location = getLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
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
                  initialCameraPosition: CameraPosition(
                    target: coordinates,
                    zoom: defaultZoom,
                  ),
                  onMapCreated: (controller) {
                    mapController = controller;
                    positionStream = startTracking(mapController);
                    appBar = showAppBar(context, mapController);
                    floatingActionButton =
                        showFloatingActionButton(positionStream, mapController);
                  },
                  onCameraMoveStarted: () => positionStream.cancel(),
                  onCameraMove: (position) => coordinates = position.target,
                  onCameraIdle: () async {
                    isHotspot = await getInfo(context, coordinates, circles);
                    setState(() {});
                    showSnackBar(context, coordinates, circles, isHotspot);
                  },
                  circles: circles,
                  zoomControlsEnabled: false,
                  rotateGesturesEnabled: false,
                ),
                Align(
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
