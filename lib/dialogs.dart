import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:e_roubo/text_helpers.dart';
import 'package:e_roubo/helpers.dart';

class CircleInfo extends StatelessWidget {
  CircleInfo({this.date, this.time});

  final String date;
  final String time;
  final double edgeSize = 20;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('Informação do Roubo', textAlign: TextAlign.center),
      contentPadding:
          EdgeInsets.symmetric(vertical: edgeSize, horizontal: 2 * edgeSize),
      children: [
        IconTextH(icons: [Icon(Icons.event)], text: '$date'),
        IconTextH(icons: [Icon(Icons.schedule)], text: '$time')
      ],
    );
  }
}

class SearchDialog extends StatelessWidget {
  SearchDialog({@required this.controller});

  final GoogleMapController controller;
  final double edgeSize = 20;
  final double fontSize = 20;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
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
              if (address.isNotEmpty) {
                List<Location> locations = await locationFromAddress(address);
                if (locations.isNotEmpty) {
                  LatLng target = LatLng(
                      locations.first.latitude, locations.first.longitude);
                  moveCameraTo(target, controller);
                }
              }
            } catch (e) {}
          },
        )
      ],
    );
  }
}

class MenuDialog extends StatelessWidget {
  final double edgeSize = 20;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('Menu', textAlign: TextAlign.center),
      contentPadding: EdgeInsets.all(edgeSize),
      children: [
        SimpleDialogOption(
            onPressed: () =>
                showDialog(context: context, child: Instructions()),
            child: IconTextH(icons: [Icon(Icons.help)], text: 'Instruções')),
        SimpleDialogOption(
            onPressed: () => showMoreInfo(context),
            child: IconTextH(icons: [Icon(Icons.info)], text: 'Sobre'))
      ],
    );
  }
}

class Instructions extends StatelessWidget {
  final double edgeSize = 20;
  final double fontSize = 20;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Instruções', textAlign: TextAlign.center),
      contentPadding: EdgeInsets.all(edgeSize),
      contentTextStyle: TextStyle(fontSize: fontSize, color: Colors.black),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconTextH(
                text:
                    'Cada roubo é representado por um círculo vermelho no mapa. A tonalidade interna representa a proximidade com o seu horário:'),
            IconTextH(icons: [
              Icon(Icons.lens, color: Colors.white),
              Icon(Icons.panorama_fish_eye, color: Colors.red)
            ], text: 'Roubo ocorrido em um horário muito distante'),
            IconTextH(icons: [
              Icon(Icons.lens, color: Colors.grey),
              Icon(Icons.panorama_fish_eye, color: Colors.red)
            ], text: 'Roubo ocorrido em um horário distante'),
            IconTextH(icons: [
              Icon(Icons.lens, color: Colors.black),
              Icon(Icons.panorama_fish_eye, color: Colors.red)
            ], text: 'Roubo ocorrido em um horário próximo'),
            IconTextH(text: 'Alertas aparecem na parte de baixo da tela:'),
            IconTextH(
                icons: [Icon(Icons.warning, color: Colors.yellow)],
                text: 'Atenção ao uso do celular'),
            IconTextH(
                icons: [Icon(Icons.warning, color: Colors.red)],
                text: 'Evite o uso do celular'),
            IconTextH(
                text:
                    'Os dados são apresentados de acordo com a sua localização. Arraste a tela para pesquisar ao redor.'),
            IconTextH(
                icons: [Icon(Icons.place, color: Colors.blue)],
                text: 'Sua localização'),
            IconTextH(
                icons: [Icon(Icons.search)],
                text: 'Ferramenta de busca de local'),
            IconTextH(
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
    );
  }
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
