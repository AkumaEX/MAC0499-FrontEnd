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
            onPressed: () => showInstructions(context),
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

Future showInstructions(BuildContext context) {
  return showDialog(
      context: context,
      child: AlertDialog(
        title: Text('Instruções', textAlign: TextAlign.center),
        contentPadding: EdgeInsets.all(edgeSize),
        contentTextStyle: TextStyle(fontSize: fontSize, color: Colors.black),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                  child: Text(
                      'Cada roubo é representado por um círculo vermelho no mapa. A tonalidade interna representa a proximidade com o seu horário:')),
              SizedBox(height: edgeSize),
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
                      child:
                          Text('Roubo ocorrido em um horário muito distante'))
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
                  Flexible(child: Text('Roubo ocorrido em um horário distante'))
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
                  Flexible(child: Text('Roubo ocorrido em um horário próximo'))
                ],
              ),
              SizedBox(height: edgeSize),
              Flexible(
                  child: Text('Alertas aparecem na parte de baixo da tela')),
              SizedBox(height: edgeSize),
              Row(
                children: [
                  Icon(Icons.warning, color: Colors.yellow),
                  SizedBox(width: edgeSize),
                  Flexible(child: Text('Atenção ao uso do celular'))
                ],
              ),
              SizedBox(height: edgeSize),
              Row(
                children: [
                  Icon(Icons.warning, color: Colors.red),
                  SizedBox(width: edgeSize),
                  Flexible(child: Text('Evite o uso do celular'))
                ],
              ),
              SizedBox(height: edgeSize),
              Flexible(
                  child: Text(
                      'Os dados são apresentados de acordo com a sua localização. Arraste a tela para pesquisar ao redor')),
              SizedBox(height: edgeSize),
              Row(
                children: [
                  Icon(Icons.place, color: Colors.blue),
                  SizedBox(width: edgeSize),
                  Flexible(child: Text('Sua localização'))
                ],
              ),
              SizedBox(height: edgeSize),
              Row(
                children: [
                  Icon(Icons.search),
                  SizedBox(width: edgeSize),
                  Flexible(child: Text('Ferramenta de busca de local'))
                ],
              ),
              SizedBox(height: edgeSize),
              Row(
                children: [
                  Icon(Icons.my_location),
                  SizedBox(width: edgeSize),
                  Flexible(child: Text('Botão para retornar à sua localização'))
                ],
              ),
            ],
          ),
        ),
        actions: [
          FlatButton(
            padding: EdgeInsets.only(right: edgeSize, bottom: edgeSize),
            child: Text('OK', style: TextStyle(fontSize: fontSize)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
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
