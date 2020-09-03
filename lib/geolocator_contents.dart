import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

StreamSubscription<Position> startTracking(GoogleMapController controller) {
  int distance = 10;
  var locationOptions = LocationOptions(
      accuracy: LocationAccuracy.bestForNavigation, distanceFilter: distance);
  return Geolocator().getPositionStream(locationOptions).listen(
        (Position position) => moveCameraTo(
            LatLng(position.latitude, position.longitude), controller));
}

void moveCameraTo(LatLng target, GoogleMapController controller) {
  controller.animateCamera(
    CameraUpdate.newLatLng(target),
  );
}

Future<LatLng> getLocation() async {
  bool isLocationEnabled = await Geolocator().isLocationServiceEnabled();
  if (isLocationEnabled) {
    Position position = await Geolocator().getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    return LatLng(position.latitude, position.longitude);
  } else {
    return LatLng(-23.5489, -46.6388);
  }
}

Future<bool> checkDistance(LatLng coordinates, Set<Circle> circles) async {
  double distRadius = 300;
  for (Circle circle in circles) {
    double distance = await Geolocator().distanceBetween(coordinates.latitude,
        coordinates.longitude, circle.center.latitude, circle.center.longitude);
    if (distance < distRadius) {
      return true;
    }
  }
  return false;
}
