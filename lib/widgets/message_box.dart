import 'package:flutter/material.dart';

class MessageBox extends StatelessWidget {
  final bool isUser;
  final String text;

  const MessageBox({Key key, this.isUser, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: this.isUser
          ? BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  bottomLeft: Radius.circular(25.0),
                  bottomRight: Radius.circular(25.0)),
              color: Theme.of(context).accentColor,
            )
          : BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(25.0),
                  bottomLeft: Radius.circular(25.0),
                  bottomRight: Radius.circular(25.0)),
            ),
      padding: EdgeInsets.all(12.0),
      margin: EdgeInsets.all(16.0),
      child: Text(this.text),
    );
  }
}
