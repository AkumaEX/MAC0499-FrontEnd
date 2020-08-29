import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:e_roubo/dialogs.dart';
import 'package:e_roubo/geolocator_contents.dart';

double fontSize = 20;
double iconSize = 40;
Color bgColor = Colors.black54.withOpacity(0.5);

AppBar showAppBar(BuildContext context, GoogleMapController controller) {
  return AppBar(
    title: Text('eRoubo', style: GoogleFonts.righteous(fontSize: fontSize)),
    centerTitle: true,
    backgroundColor: bgColor,
    actions: [
      IconButton(
        icon: Icon(Icons.search),
        onPressed: () => showSearchDialog(context, controller),
      ),
      IconButton(
        icon: Icon(Icons.more_vert),
        onPressed: () => showPopupMenu(context),
      )
    ],
  );
}

FloatingActionButton showFloatingActionButton(StreamSubscription positionStream,
    LatLng coordinates, GoogleMapController controller) {
  return FloatingActionButton(
      child: Icon(Icons.my_location),
      backgroundColor: bgColor,
      onPressed: () {
        positionStream.cancel();
        positionStream = startTracking(coordinates, controller);
      });
}

SnackBar snackBar(bool isHotspot, bool isNear) {
  return SnackBar(
    backgroundColor: bgColor,
    duration: Duration(days: 30),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.warning,
          size: iconSize,
          color: (isHotspot && isNear) ? Colors.red : Colors.yellow,
        ),
        Flexible(
            child: Text(
          (isHotspot && isNear)
              ? 'Área de risco e próximo a um local de crime'
              : (isHotspot) ? 'Área de risco' : 'Próximo a um local de crime',
          style: TextStyle(fontSize: fontSize),
          textAlign: TextAlign.center,
        ))
      ],
    ),
  );
}
