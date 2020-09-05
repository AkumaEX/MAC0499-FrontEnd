import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:e_roubo/geolocator_contents.dart';
import 'package:e_roubo/helpers.dart';
import 'package:e_roubo/dialogs.dart';
import 'package:e_roubo/text_helpers.dart';

AppBar showAppBar(BuildContext context, GoogleMapController controller) {
  Color bgColor = Colors.black54.withOpacity(0.5);
  double fontSize = 20;
  return AppBar(
    title: Text('eRoubo', style: GoogleFonts.righteous(fontSize: fontSize)),
    centerTitle: true,
    backgroundColor: bgColor,
    actions: [
      IconButton(
          icon: Icon(Icons.search),
          onPressed: () => showDialog(
              context: context, child: SearchDialog(controller: controller))),
      IconButton(
        icon: Icon(Icons.more_vert),
        onPressed: () => showDialog(context: context, child: MenuDialog()),
      )
    ],
  );
}

Future<Map> getClusterData(LatLng location) async {
  String endPoint = 'http://104.155.175.253/ml/api';
  try {
    String url =
        '$endPoint?latitude=${location.latitude}&longitude=${location.longitude}';
    http.Response response = await http.get(url);
    return json.decode(response.body);
  } catch (e) {
    return Map();
  }
}

Future getInfo(
    BuildContext context, LatLng coordinates, Set<Circle> circles) async {
  Map data = await getClusterData(coordinates);
  if (data.isNotEmpty) {
    Set<Circle> newCircles = Set<Circle>();
    for (var info in data['geo']) {
      newCircles.add(newCircle(context, info[0], info[1], info[2], info[3]));
    }
    circles.addAll(newCircles);
    return data['hotspot'];
  }
  return null;
}

void showSnackBar(BuildContext context, LatLng coordinates, Set<Circle> circles,
    isHotspot) async {
  bool isNear = await checkDistance(coordinates, circles);
  Scaffold.of(context).hideCurrentSnackBar();
  Scaffold.of(context).showSnackBar(snackBar(isHotspot, isNear));
}

SnackBar snackBar(bool isHotspot, bool isNear) {
  return SnackBar(
    backgroundColor: Colors.black54.withOpacity(0.5),
    duration: Duration(days: 30),
    content: snackBarMessage(isHotspot, isNear),
  );
}

SnackBarTile snackBarMessage(bool isHotspot, bool isNear) {
  double iconSize = 40;
  if (isHotspot == null) {
    return SnackBarTile(
      icon: Icon(Icons.sync_problem, color: Colors.blue, size: iconSize),
      title: 'Sem conexão',
      description: 'Problemas com a obtenção de dados. Verifique sua conexão',
    );
  } else if (isHotspot && isNear) {
    return SnackBarTile(
      icon: Icon(Icons.warning, color: Colors.red, size: iconSize),
      title: 'Guarde o celular',
      description:
          'Previsão de roubos acima do normal nesta área, e próximo a um roubo recente',
    );
  } else if (isHotspot && !isNear) {
    return SnackBarTile(
      icon: Icon(Icons.warning, color: Colors.yellow, size: iconSize),
      title: 'Atenção',
      description:
          'Previsão de roubos acima do normal nesta área, mas longe da área de risco',
    );
  } else if (!isHotspot && isNear) {
    return SnackBarTile(
      icon: Icon(Icons.warning, color: Colors.yellow, size: iconSize),
      title: 'Área de Risco',
      description:
          'Previsão de roubos abaixo do normal nesta área, mas próximo a um roubo recente',
    );
  } else {
    return SnackBarTile(
      icon: Icon(Icons.check_circle, color: Colors.green, size: iconSize),
      title: 'Seguro',
      description: 'Previsão de roubos abaixo do normal nesta área',
    );
  }
}
