import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

double fontSize = 20;
double edgeSize = 20;
double distRadius = 300;
double circleRadius = 30;
double iconSize = 40;
Color bgColor = Colors.black54.withOpacity(0.5);

Stack showLoadingScreen() {
  return Stack(
    key: Key('loading'),
    children: [
      Container(
        color: Colors.black87,
      ),
      Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text('eRoubo',
                  style:
                      GoogleFonts.righteous(fontSize: 80, color: Colors.white)),
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text('Evite o Roubo de seu Celular',
                  style: GoogleFonts.righteous(
                      fontSize: fontSize, color: Colors.white)),
            ),
            Padding(
              padding: EdgeInsets.only(top: 100),
              child: CircularProgressIndicator(),
            )
          ],
        ),
      )
    ],
  );
}

AppBar showAppBar(BuildContext context) {
  return AppBar(
    title: Text('eRoubo', style: GoogleFonts.righteous()),
    centerTitle: true,
    backgroundColor: bgColor,
    actions: [
      IconButton(
        icon: Icon(Icons.more_vert),
        onPressed: () => showPopupMenu(context),
      )
    ],
  );
}

Future<LatLng> getLocation(Geolocator geolocator) async {
  bool isLocationEnabled = await geolocator.isLocationServiceEnabled();
  if (isLocationEnabled) {
    Position position = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    return LatLng(position.latitude, position.longitude);
  } else {
    return LatLng(-23.5489, -46.6388);
  }
}

Future<Map> getClusterData(String endPoint, LatLng location) async {
  var url =
      '$endPoint?latitude=${location.latitude}&longitude=${location.longitude}';
  http.Response response = await http.get(url);
  return json.decode(response.body);
}

Circle newCircle(BuildContext context, String date, String time,
    double latitude, double longitude) {
  return Circle(
    circleId: CircleId('$latitude$longitude'),
    center: LatLng(latitude, longitude),
    radius: circleRadius,
    strokeWidth: 3,
    strokeColor: Colors.red,
    fillColor: Colors.black.withOpacity(getOpacityFromTime(time)),
    consumeTapEvents: true,
    onTap: () => showDateAndTimeDialog(context, date, time),
  );
}

double getOpacityFromTime(String time) {
  try {
    List hourMinute = time.split(':');
    int hour = int.parse(hourMinute[0]);
    int minute = int.parse(hourMinute[1]);
    return 1 - (getTimeDiffFromNow(hour, minute).inMinutes / 720);
  } catch (e) {
    return 0.5;
  }
}

Duration getTimeDiffFromNow(hour, minute) {
  DateTime now = DateTime.now();
  DateTime other =
      DateTime(now.year, now.month, now.day, hour, minute, now.second);
  if (now.isAfter(other)) {
    Duration diff = now.difference(other);
    if (diff.inHours < 12) {
      return diff;
    } else {
      other = other.add(Duration(days: 1));
      return other.difference(now);
    }
  } else {
    Duration diff = other.difference(now);
    if (diff.inHours < 12) {
      return diff;
    } else {
      other = other.subtract(Duration(days: 1));
      return now.difference(other);
    }
  }
}

Future showDateAndTimeDialog(BuildContext context, String date, String time) {
  return showDialog(
      context: context,
      child: Dialog(
        child: Padding(
          padding: EdgeInsets.all(edgeSize),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Informações do Roubo',
                  style: TextStyle(
                      fontSize: fontSize, fontWeight: FontWeight.bold)),
              Text('Data: $date', style: TextStyle(fontSize: fontSize)),
              Text('Horário: $time', style: TextStyle(fontSize: fontSize))
            ],
          ),
        ),
      ));
}

Future<bool> checkDistance(
    Geolocator geolocator, LatLng coordinates, Set<Circle> circles) async {
  for (Circle circle in circles) {
    double distance = await geolocator.distanceBetween(coordinates.latitude,
        coordinates.longitude, circle.center.latitude, circle.center.longitude);
    if (distance < distRadius) {
      return true;
    }
  }
  return false;
}

SnackBar snackBar(bool isHotspot, bool isNear) {
  return SnackBar(
    backgroundColor: Colors.black54,
    duration: Duration(days: 30),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.warning,
          size: iconSize,
          color: (isHotspot == true && isNear == true)
              ? Colors.red
              : Colors.yellow,
        ),
        Flexible(
            child: Text(
          (isHotspot == true && isNear == true)
              ? 'Área de risco e próximo a um local de crime'
              : (isHotspot == true)
                  ? 'Área de risco'
                  : 'Próximo a um local de crime',
          style: TextStyle(fontSize: fontSize),
          textAlign: TextAlign.center,
        ))
      ],
    ),
  );
}

Future showPopupMenu(BuildContext context) {
  return showDialog(
      context: context,
      child: SimpleDialog(
        title: Text('Selecione',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold)),
        children: [
          SimpleDialogOption(
            onPressed: () => showHelp(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.help),
                Padding(
                  padding: EdgeInsets.all(edgeSize),
                  child: Text(
                    'Ajuda',
                    style: TextStyle(fontSize: fontSize),
                  ),
                )
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () => showMoreInfo(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.info),
                Padding(
                  padding: EdgeInsets.all(edgeSize),
                  child: Text(
                    'Sobre',
                    style: TextStyle(fontSize: fontSize),
                  ),
                )
              ],
            ),
          )
        ],
      ));
}

Future showHelp(BuildContext context) {
  return showDialog(
      context: context,
      child: Dialog(
        child: Padding(
          padding: EdgeInsets.all(edgeSize),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Ajuda',
                  style: TextStyle(
                      fontSize: fontSize, fontWeight: FontWeight.bold)),
              SizedBox(height: edgeSize),
              Row(
                children: [
                  Stack(
                    children: [
                      Icon(Icons.lens, color: Colors.grey),
                      Icon(Icons.panorama_fish_eye, color: Colors.red),
                    ],
                  ),
                  SizedBox(width: edgeSize),
                  Flexible(
                      child: Text('Crime que ocorreu em horário distante',
                          style: TextStyle(fontSize: fontSize)))
                ],
              ),
              SizedBox(height: edgeSize),
              Row(
                children: [
                  Stack(
                    children: [
                      Icon(Icons.lens, color: Colors.black),
                      Icon(Icons.panorama_fish_eye, color: Colors.red)
                    ],
                  ),
                  SizedBox(width: edgeSize),
                  Flexible(
                    child: Text('Crime que ocorreu em horário próximo',
                        style: TextStyle(fontSize: fontSize)),
                  )
                ],
              ),
              SizedBox(height: edgeSize),
              Row(
                children: [
                  Icon(Icons.place, color: Colors.blue),
                  SizedBox(width: edgeSize),
                  Flexible(
                    child: Text('Sua localização',
                        style: TextStyle(fontSize: fontSize)),
                  )
                ],
              )
            ],
          ),
        ),
      ));
}

void showMoreInfo(BuildContext context) {
  return showAboutDialog(
    context: context,
    applicationName: 'eRoubo',
    applicationVersion: '0.1.0',
    applicationLegalese:
        'Desenvolvido por Julio Kenji Ueda como parte do Trabalho de Conclusão do Curso de Bacharelado em Ciência da Computação do Instituto de Matemática e Estatística da Universidade de São Paulo',
  );
}
