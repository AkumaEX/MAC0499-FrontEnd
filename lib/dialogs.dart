import 'package:e_roubo/text_helpers.dart';
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
        contentPadding:
            EdgeInsets.symmetric(vertical: edgeSize, horizontal: 2 * edgeSize),
        children: [
          IconText(icons: [Icon(Icons.event)], text: '$date'),
          IconText(icons: [Icon(Icons.schedule)], text: '$time')
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
              child: IconText(icons: [Icon(Icons.help)], text: 'Instruções')),
          SimpleDialogOption(
              onPressed: () => showMoreInfo(context),
              child: IconText(icons: [Icon(Icons.info)], text: 'Sobre'))
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
              IconText(
                  text:
                      'Cada roubo é representado por um círculo vermelho no mapa. A tonalidade interna representa a proximidade com o seu horário:'),
              IconText(icons: [
                Icon(Icons.lens, color: Colors.white),
                Icon(Icons.panorama_fish_eye, color: Colors.red)
              ], text: 'Roubo ocorrido em um horário muito distante'),
              IconText(icons: [
                Icon(Icons.lens, color: Colors.grey),
                Icon(Icons.panorama_fish_eye, color: Colors.red)
              ], text: 'Roubo ocorrido em um horário distante'),
              IconText(icons: [
                Icon(Icons.lens, color: Colors.black),
                Icon(Icons.panorama_fish_eye, color: Colors.red)
              ], text: 'Roubo ocorrido em um horário próximo'),
              IconText(text: 'Alertas aparecem na parte de baixo da tela:'),
              IconText(
                  icons: [Icon(Icons.warning, color: Colors.yellow)],
                  text: 'Atenção ao uso do celular'),
              IconText(
                  icons: [Icon(Icons.warning, color: Colors.red)],
                  text: 'Evite o uso do celular'),
              IconText(
                  text:
                      'Os dados são apresentados de acordo com a sua localização. Arraste a tela para pesquisar ao redor.'),
              IconText(
                  icons: [Icon(Icons.place, color: Colors.blue)],
                  text: 'Sua localização'),
              IconText(
                  icons: [Icon(Icons.search)],
                  text: 'Ferramenta de busca de local'),
              IconText(
                  icons: [Icon(Icons.my_location)],
                  text: 'Botão para retornar à sua localização'),
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
