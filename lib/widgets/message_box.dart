import 'package:flutter/material.dart';

class MessageBox extends StatelessWidget {
  final bool isUser;
  final String text;

  const MessageBox({Key key, this.isUser, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment:
          isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
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
                  color: Theme.of(context).primaryColor),
          padding: EdgeInsets.all(12.0),
          margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Text(
            this.text,
            style: isUser
                ? TextStyle(color: Colors.white, fontSize: 20.0)
                : TextStyle(
                    color: Theme.of(context).accentColor, fontSize: 20.0),
          ),
        ),
      ],
    );
  }
}
