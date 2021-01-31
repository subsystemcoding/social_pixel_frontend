import 'package:flutter/material.dart';

enum MessageType {
  Text,
  Photo,
  SharedPost,
}

class MessageBox extends StatelessWidget {
  final bool isUser;
  final MessageType type;
  final String text;

  const MessageBox({
    Key key,
    this.isUser,
    this.text,
    this.type,
  }) : super(key: key);

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
          padding: EdgeInsets.all(8.0),
          margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: _buildMessage(context),
        ),
      ],
    );
  }

  Widget _buildMessage(BuildContext context) {
    switch (this.type) {
      case MessageType.Text:
        return _buildTextMessage(context);
      case MessageType.Photo:
        return _buildPhotoMessage(context);
      default:
        return Container();
    }
  }

  Widget _buildTextMessage(BuildContext context) {
    return Text(
      this.text,
      style: isUser
          ? TextStyle(color: Colors.white, fontSize: 12.0)
          : TextStyle(color: Theme.of(context).accentColor, fontSize: 12.0),
    );
  }

  Widget _buildPhotoMessage(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25.0),
        child: Image(
          image: NetworkImage(this.text),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
