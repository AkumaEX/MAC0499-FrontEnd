import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:e_roubo/helpers.dart';

class CircleInfo extends StatelessWidget {
  CircleInfo({this.date, this.time});

  final String date;
  final String time;
  final double verticalEdge = 20;
  final double horizontalEdge = 30;
  final double fontSize = 20;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('Informação do Roubo', textAlign: TextAlign.center),
      contentPadding: EdgeInsets.symmetric(
          vertical: verticalEdge, horizontal: horizontalEdge),
      children: [
        ListTile(
          leading: Icon(Icons.event),
          title: Text('Data', style: TextStyle(fontSize: fontSize)),
          subtitle: Text(date, style: TextStyle(fontSize: fontSize)),
        ),
        ListTile(
          leading: Icon(Icons.schedule),
          title: Text('Horário', style: TextStyle(fontSize: fontSize)),
          subtitle: Text(time, style: TextStyle(fontSize: fontSize)),
        )
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
  final double verticalEdge = 20;
  final double horizontalEdge = 30;
  final double fontSize = 20;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('Menu', textAlign: TextAlign.center),
      contentPadding: EdgeInsets.symmetric(
          vertical: verticalEdge, horizontal: horizontalEdge),
      children: [
        ListTile(
          leading: Icon(Icons.help),
          title: Text('Instruções', style: TextStyle(fontSize: fontSize)),
          onTap: () => showDialog(context: context, child: Instructions()),
        ),
        ListTile(
          leading: Icon(Icons.info),
          title: Text('Sobre', style: TextStyle(fontSize: fontSize)),
          onTap: () => showMoreInfo(context),
        ),
      ],
    );
  }
}

class Instructions extends StatelessWidget {
  final double edgeSize = 20;
  final double fontSize = 17;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Instruções', textAlign: TextAlign.center),
      scrollable: true,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(
                'Cada roubo é representado por um círculo vermelho no mapa. A tonalidade interna representa a proximidade com o seu horário:',
                style: TextStyle(fontSize: fontSize)),
          ),
          ListTile(
            leading: Stack(children: [
              Icon(Icons.lens, color: Colors.white),
              Icon(Icons.panorama_fish_eye, color: Colors.red)
            ]),
            title: Text('Roubo ocorrido em um horário muito distante',
                style: TextStyle(fontSize: fontSize)),
          ),
          ListTile(
            leading: Stack(children: [
              Icon(Icons.lens, color: Colors.grey),
              Icon(Icons.panorama_fish_eye, color: Colors.red)
            ]),
            title: Text('Roubo ocorrido em um horário distante',
                style: TextStyle(fontSize: fontSize)),
          ),
          ListTile(
            leading: Stack(children: [
              Icon(Icons.lens, color: Colors.black),
              Icon(Icons.panorama_fish_eye, color: Colors.red)
            ]),
            title: Text('Roubo ocorrido em um horário próximo',
                style: TextStyle(fontSize: fontSize)),
          ),
          ListTile(
            title: Text('Alertas aparecem na parte de baixo da tela:',
                style: TextStyle(fontSize: fontSize)),
          ),
          ListTile(
              leading: Icon(Icons.check_circle, color: Colors.green),
              title: Text('Aparentemente seguro',
                  style: TextStyle(fontSize: fontSize))),
          ListTile(
            leading: Icon(Icons.warning, color: Colors.yellow),
            title: Text('Atenção ao uso do celular',
                style: TextStyle(fontSize: fontSize)),
          ),
          ListTile(
            leading: Icon(Icons.pan_tool, color: Colors.red),
            title: Text('Evite o uso do celular',
                style: TextStyle(fontSize: fontSize)),
          ),
          ListTile(
            title: Text(
                'Os dados são apresentados de acordo com a sua localização. Arraste a tela para pesquisar ao redor.',
                style: TextStyle(fontSize: fontSize)),
          ),
          ListTile(
            leading: Stack(
              children: [
                Icon(Icons.arrow_drop_up, color: Colors.blue),
                Padding(
                    padding: EdgeInsets.only(top: 15, left: 2),
                    child: Icon(Icons.fiber_manual_record,
                        size: 20, color: Colors.blue))
              ],
            ),
            title:
                Text('Sua localização', style: TextStyle(fontSize: fontSize)),
          ),
          ListTile(
              leading: Icon(Icons.location_searching, color: Colors.blue),
              title: Text('Local de busca de dados',
                  style: TextStyle(fontSize: fontSize))),
          ListTile(
            leading: Icon(Icons.search),
            title: Text('Ferramenta de busca de local',
                style: TextStyle(fontSize: fontSize)),
          ),
          ListTile(
            leading: Icon(Icons.my_location),
            title: Text('Botão para retornar à sua localização',
                style: TextStyle(fontSize: fontSize)),
          ),
        ],
      ),
      actions: [
        FlatButton(
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
