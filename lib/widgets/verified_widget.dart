import 'package:flutter/material.dart';
import 'package:tinycolor/tinycolor.dart';

class VerifiedWidget extends StatelessWidget {
  const VerifiedWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.0),
      padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: TinyColor(Theme.of(context).accentColor).lighten(35).color,
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      child: Text(
        "Verified",
        style: TextStyle(
            fontSize: 16.0,
            color: TinyColor(Theme.of(context).accentColor).lighten(0).color),
      ),
    );
  }
}
