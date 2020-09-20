import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:e_roubo/helpers.dart';

StreamSubscription<Position> startTracking(GoogleMapController controller) {
  return getPositionStream(desiredAccuracy: LocationAccuracy.bestForNavigation, distanceFilter: 10)
      .listen((Position position) => moveCameraTo(LatLng(position.latitude, position.longitude), controller));
}

Future<LatLng> getLocation() async {
  Position position = await getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
  return LatLng(position.latitude, position.longitude);
}

Future<bool> checkDistance(LatLng coordinates, Set<Circle> circles) async {
  double distRadius = 300;
  for (Circle circle in circles) {
    double distance =
        GeolocatorPlatform.instance.distanceBetween(coordinates.latitude, coordinates.longitude, circle.center.latitude, circle.center.longitude);
    if (distance < distRadius) {
      return true;
    }
  }
  return false;
}
