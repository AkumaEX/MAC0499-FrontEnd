import 'package:flutter/material.dart';

class IconTextH extends StatelessWidget {
  IconTextH({@required this.text, this.icons});

  final List<Icon> icons;
  final String text;
  final double fontsize = 20;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        children: [
          if (icons != null) Stack(children: icons),
          if (icons != null) SizedBox(width: 20),
          Flexible(child: Text(text, style: TextStyle(fontSize: fontsize)))
        ],
      ),
    );
  }
}

class SnackBarTile extends StatelessWidget {
  SnackBarTile(
      {@required this.icon, @required this.title, @required this.description});

  final Icon icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      maintainState: true,
      leading: icon,
      title: Text(title, style: TextStyle(fontSize: 20, color: Colors.white)),
      children: [
        Text(description, style: TextStyle(fontSize: 15, color: Colors.white))
      ],
    );
  }
}
