import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

double fontSize = 20;
double edgeSize = 20;

Future showDateAndTimeDialog(BuildContext context, String date, String time) {
  return showDialog(
      context: context,
      child: SimpleDialog(
        title: Text('Informação do Roubo', textAlign: TextAlign.center),
        children: [
          Text('Data: $date',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: fontSize)),
          Text('Horário: $time',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: fontSize)),
        ],
      ));
}

Future showSearchDialog(
    BuildContext context, GoogleMapController mapController) {
  return showDialog(
    context: context,
    child: SimpleDialog(
      title: Text('Busca', textAlign: TextAlign.center),
      contentPadding: EdgeInsets.all(edgeSize),
      children: [
        TextField(
          autofocus: true,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: fontSize),
          onEditingComplete: () => Navigator.pop(context),
          onSubmitted: (address) async {
            try {
              List<Placemark> placemarks =
                  await Geolocator().placemarkFromAddress(address);
              if (placemarks.isNotEmpty) {
                Position position = placemarks.first.position;
                LatLng coordinates =
                    LatLng(position.latitude, position.longitude);
                mapController
                    .animateCamera(CameraUpdate.newLatLng(coordinates));
              }
            } catch (e) {}
          },
        )
      ],
    ),
  );
}

Future showPopupMenu(BuildContext context) {
  return showDialog(
      context: context,
      child: SimpleDialog(
        title: Text('Menu', textAlign: TextAlign.center),
        contentPadding: EdgeInsets.all(edgeSize),
        children: [
          SimpleDialogOption(
            onPressed: () => showHelp(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.help),
                SizedBox(width: edgeSize),
                Text('Instruções', style: TextStyle(fontSize: fontSize)),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () => showMoreInfo(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.info),
                SizedBox(width: edgeSize),
                Text('Sobre', style: TextStyle(fontSize: fontSize)),
              ],
            ),
          )
        ],
      ));
}

Future showHelp(BuildContext context) {
  return showDialog(
      context: context,
      child: SimpleDialog(
        title: Text('Instruções', textAlign: TextAlign.center),
        contentPadding: EdgeInsets.all(edgeSize),
        children: [
          Row(
            children: [
              Stack(
                children: [
                  Icon(Icons.lens, color: Colors.white),
                  Icon(Icons.panorama_fish_eye, color: Colors.red),
                ],
              ),
              SizedBox(width: edgeSize),
              Flexible(
                  child: Text('Crime que ocorreu em horário muito distante',
                      style: TextStyle(fontSize: fontSize)))
            ],
          ),
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
