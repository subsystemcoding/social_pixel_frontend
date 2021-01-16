import 'package:flutter/material.dart';

class RaisedContainer extends StatelessWidget {
  final EdgeInsets padding;
  final EdgeInsets margin;
  final double width;
  final double height;
  final Color color;
  final Widget child;

  const RaisedContainer({
    Key key,
    this.padding = const EdgeInsets.symmetric(horizontal: 28.0),
    this.child,
    this.width,
    this.height,
    this.color,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: this.margin,
      padding: this.padding,
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(25.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[300],
              blurRadius: 30.0,
              spreadRadius: 0.0,
            )
          ]),
      child: child,
    );
  }
}
