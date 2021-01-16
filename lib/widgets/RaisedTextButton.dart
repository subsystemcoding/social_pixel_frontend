import 'package:flutter/material.dart';

class RaisedTextButton extends StatelessWidget {
  final EdgeInsets padding;
  final Color backgroundColor;
  final Color textColor;
  final double textSize;
  final String text;

  const RaisedTextButton({
    Key key,
    this.padding = const EdgeInsets.symmetric(horizontal: 28.0),
    this.backgroundColor,
    this.textColor,
    this.textSize = 20.0,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: this.padding,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(25.0), boxShadow: [
        BoxShadow(
          color: Colors.grey[300],
          blurRadius: 30.0,
          spreadRadius: 0.0,
        )
      ]),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          primary: this.textColor,
          backgroundColor: this.backgroundColor,
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: this.textSize),
        ),
        onPressed: () {},
      ),
    );
  }
}
