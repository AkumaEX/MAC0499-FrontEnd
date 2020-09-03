import 'package:e_roubo/google_maps.dart';
import 'package:e_roubo/helpers.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:e_roubo/geolocator_contents.dart';

void main() {
  runApp(ERoubo());
}

class ERoubo extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'eRoubo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.black,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoadingScreen(),
    );
  }
}

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

  @override
  void initState() {
    super.initState();
    getLocation().then((location) => Navigator.of(context).pushReplacement(transition(location)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: showLoadingScreen());
  }
}

Route transition(LatLng coordinates) {
  return PageRouteBuilder(
    transitionDuration: Duration(seconds: 5),
    pageBuilder: (context, animation, secondaryAnimation) => GoogleMaps(coordinates),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}
