import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMaps extends StatefulWidget {
  @override
  _GoogleMapsState createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {
  Location location = Location();
  Map clusterData;
  Set<Marker> markers = Set<Marker>();
  double defaultZoom = 15;
  LatLng currentPosition = LatLng(-23.5677947, -46.7365914);
  GoogleMapController _controller;
  StreamSubscription<LocationData> locationSubscription;

  Future getLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    locationSubscription = location.onLocationChanged.listen((locationData) {
      currentPosition = LatLng(locationData.latitude, locationData.longitude);
    });
  }

  Future<Map> getClusterData(LatLng currentPosition) async {
    var url =
        'http://104.155.175.253/ml/api?latitude=${currentPosition.latitude}&longitude=${currentPosition.longitude}';
    http.Response response = await http.get(url);
    return json.decode(response.body);
  }

  void addMarkers(List locations) {
    locations.forEach((location) {
      markers.add(Marker(
          markerId: MarkerId('${location[2]}${location[3]}'),
          infoWindow: InfoWindow(title: location[0], snippet: location[1]),
          position: LatLng(location[2], location[3])),);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        GoogleMap(
            initialCameraPosition:
                CameraPosition(target: currentPosition, zoom: defaultZoom),
            onMapCreated: (controller) => _controller = controller,
            onCameraMoveStarted: () {
              if (locationSubscription != null) {
                locationSubscription.cancel();
              }
            },
            onCameraMove: (position) => currentPosition = position.target,
            onCameraIdle: () async {
              clusterData = await getClusterData(currentPosition);
              setState(() {
                addMarkers(clusterData['geo']);
              });
            },
            markers: markers),
        Align(
            alignment: Alignment.center,
            child: Icon(Icons.place, size: 40, color: Colors.red)),
        RaisedButton(
            child: Icon(Icons.my_location),
            onPressed: () {
              setState(() {
                if (locationSubscription == null) {
                  getLocation();
                } else {
                  locationSubscription.resume();
                  _controller.moveCamera(CameraUpdate.newLatLng(currentPosition));
                }
              });
            })
      ]),
    );
  }
}
