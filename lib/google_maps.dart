import 'dart:async';
import 'package:e_roubo/helpers.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:e_roubo/scaffold_contents.dart';
import 'package:e_roubo/geolocator_contents.dart';

class GoogleMaps extends StatefulWidget {
  GoogleMaps(this.coordinates);

  final LatLng coordinates;

  @override
  _GoogleMapsState createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> with TickerProviderStateMixin {
  bool isHotspot;
  bool isLoading;
  bool isTracking;
  double iconSize;
  double zoomLevel;
  Set<Circle> circles;
  Set<Polygon> polygons;
  Color bgColor;
  LatLng coordinates;
  StreamSubscription<Position> positionStream;
  GoogleMapController mapController;

  @override
  void initState() {
    isLoading = false;
    isTracking = false;
    iconSize = 40;
    zoomLevel = 15;
    circles = Set<Circle>();
    polygons = Set<Polygon>();
    bgColor = Colors.black54.withOpacity(0.5);
    coordinates = widget.coordinates;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Key('google_maps'),
      resizeToAvoidBottomPadding: false,
      extendBodyBehindAppBar: true,
      appBar: showAppBar(context, mapController),
      body: Builder(
        builder: (context) => Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: <Widget>[
            GoogleMap(
              initialCameraPosition: CameraPosition(target: coordinates, zoom: zoomLevel),
              onMapCreated: (controller) {
                mapController = controller;
                positionStream = startTracking(mapController);
              },
              onTap: (point) => moveCameraTo(point, mapController),
              onLongPress: (_) => positionStream.cancel(),
              onCameraMoveStarted: () {
                setState(() {
                  isLoading = true;
                });
              },
              onCameraMove: (position) => coordinates = position.target,
              onCameraIdle: () async {
                isHotspot = await getInfo(context, coordinates, circles, polygons);
                setState(() {
                  showSnackBar(context, coordinates, circles, isHotspot);
                  isLoading = false;
                  isTracking = false;
                });
              },
              circles: circles,
              polygons: polygons,
              zoomControlsEnabled: false,
              rotateGesturesEnabled: false,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
            ),
            Icon(Icons.location_searching, size: iconSize, color: Colors.blue),
            if (isLoading) showRipple(),
            if (isTracking) showDualRing(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: bgColor,
        child: Icon(Icons.my_location),
        onPressed: () {
          positionStream.cancel();
          setState(() {
            isTracking = true;
          });
          positionStream = startTracking(mapController);
        },
      ),
    );
  }
}
