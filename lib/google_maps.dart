import 'package:flutter/foundation.dart';
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
  Set<Circle> markers = Set<Circle>();
  double defaultZoom = 15;
  Future currentLocation;
  LatLng coordinates;
  GoogleMapController mapController;
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
    LocationData locationData = await location.getLocation();
    return LatLng(locationData.latitude, locationData.longitude);
  }

  Future<Map> getClusterData(LatLng currentLocation) async {
    var url =
        'http://104.155.175.253/ml/api?latitude=${currentLocation.latitude}&longitude=${currentLocation.longitude}';
    http.Response response = await http.get(url);
    return json.decode(response.body);
  }

  StreamSubscription<LocationData> startTracking() {
    if (locationSubscription != null) {
      locationSubscription.cancel();
    }
    return location.onLocationChanged.listen((locationData) {
      coordinates = LatLng(locationData.latitude, locationData.longitude);
      mapController.moveCamera(CameraUpdate.newLatLng(coordinates));
    });
  }

  Future showMarkers(LatLng coordinates, BuildContext context) async {
    getClusterData(coordinates).then((value) {
      value['geo'].forEach((location) {
        markers.add(
          Circle(
            circleId: CircleId('${location[2]}${location[3]}'),
            center: LatLng(location[2], location[3]),
            radius: 30,
            strokeWidth: 2,
            strokeColor: Colors.red,
            consumeTapEvents: true,
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) => Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Momento do Roubo',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            Text('Data: ${location[0]}',
                                style: TextStyle(fontSize: 20)),
                            Text('Horário: ${location[1]}',
                                style: TextStyle(fontSize: 20))
                          ],
                        ),
                      ));
            },
          ),
        );
      });
    });
  }

  @override
  void initState() {
    currentLocation = getLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: currentLocation,
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
                  if (locationSubscription != null) {
                    locationSubscription.cancel();
                  }
                },
                onCameraMove: (position) => coordinates = position.target,
                onCameraIdle: () {
                  setState(() {
                    showMarkers(coordinates, context);
                  });
                },
                circles: markers),
            Align(
                child: Icon(Icons.place, size: 40, color: Colors.red),
                alignment: Alignment.center),
          ]);
        },
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.my_location),
          onPressed: () => locationSubscription = startTracking()),
    );
  }
}
