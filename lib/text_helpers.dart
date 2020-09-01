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

class IconTextV extends StatelessWidget {
  IconTextV({@required this.text, this.icons});

  final List<Icon> icons;
  final String text;
  final double fontSize = 20;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icons != null) Stack(children: icons),
        Flexible(
            child: Text(text,
                style: TextStyle(fontSize: fontSize),
                textAlign: TextAlign.center))
      ],
    );
  }
}
