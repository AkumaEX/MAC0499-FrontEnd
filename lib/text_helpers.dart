import 'package:flutter/material.dart';

class IconText extends StatelessWidget {
  IconText({@required this.text, this.icons});

  final List<Icon> icons;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        children: [
          if (icons != null) Stack(children: icons),
          if (icons != null) SizedBox(width: 20),
          Flexible(child: Text(text, style: TextStyle(fontSize: 20)))
        ],
      ),
    );
  }
}
