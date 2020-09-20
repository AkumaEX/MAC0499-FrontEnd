import 'package:flutter/material.dart';

class SnackBarTile extends StatelessWidget {
  SnackBarTile({@required this.isHotspot, @required this.isNear});

  final bool isHotspot;
  final bool isNear;
  final double largeIcon = 40;
  final double smallIcon = 30;
  final double largeFont = 20;
  final double smallFont = 17;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: getTitleIcon(isHotspot, isNear),
      title: Text(getTitle(isHotspot, isNear), style: TextStyle(fontSize: largeFont, color: Colors.white)),
      children: [
        ListTile(
          leading: getHotspotIcon(isHotspot),
          title: Text(getHotspotText(isHotspot), style: TextStyle(fontSize: smallFont, color: Colors.white)),
        ),
        if (isHotspot != null)
          ListTile(
            leading: getIsNearIcon(isNear),
            title: Text(
              getIsNearText(isNear),
              style: TextStyle(fontSize: smallFont, color: Colors.white),
            ),
          )
      ],
    );
  }

  Icon getTitleIcon(bool isHotspot, bool isNear) {
    if (isHotspot == null) {
      return Icon(Icons.sync_problem, size: largeIcon, color: Colors.blue);
    } else if (isHotspot && isNear) {
      return Icon(Icons.pan_tool, size: largeIcon, color: Colors.red);
    } else if (isHotspot && !isNear) {
      return Icon(Icons.warning, size: largeIcon, color: Colors.yellow);
    } else if (!isHotspot && isNear) {
      return Icon(Icons.warning, size: largeIcon, color: Colors.yellow);
    } else {
      return Icon(Icons.check_circle, size: largeIcon, color: Colors.green);
    }
  }

  Icon getHotspotIcon(bool isHotspot) {
    if (isHotspot == null) {
      return Icon(Icons.signal_cellular_off, size: smallIcon, color: Colors.blue);
    } else if (isHotspot) {
      return Icon(Icons.trending_up, size: smallIcon, color: Colors.red);
    } else {
      return Icon(Icons.trending_down, size: smallIcon, color: Colors.green);
    }
  }

  Icon getIsNearIcon(bool isNear) {
    if (isNear) {
      return Icon(Icons.track_changes, size: smallIcon, color: Colors.red);
    } else {
      return Icon(Icons.track_changes, size: smallIcon, color: Colors.green);
    }
  }

  String getTitle(bool isHotspot, bool isNear) {
    if (isHotspot == null) {
      return 'Sem conexão';
    } else if (isHotspot && isNear) {
      return 'Evite o uso neste local';
    } else if (isHotspot && !isNear) {
      return 'Região potencialmente perigoso';
    } else if (!isHotspot && isNear) {
      return 'Região de roubo anterior';
    } else {
      return 'Aparentemente seguro';
    }
  }

  String getHotspotText(bool isHotspot) {
    if (isHotspot == null) {
      return 'Verifique a sua conexão com a Internet. Se o problema persistir, tente novamente mais tarde';
    } else if (isHotspot) {
      return 'Previsão de alto número de roubos nesta região';
    } else {
      return 'Previsão de baixo número de roubos nesta região';
    }
  }

  String getIsNearText(bool isNear) {
    if (isNear) {
      return 'Próximo de um local de roubo';
    } else {
      return 'Longe de um local de roubo';
    }
  }
}
