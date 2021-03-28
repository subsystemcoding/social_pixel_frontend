import 'package:flutter/material.dart';
import 'package:socialpixel/data/models/post.dart';

class MessageBox extends StatelessWidget {
  final bool isUser;
  final String text;
  final Post post;
  final String imageLink;

  const MessageBox({
    Key key,
    this.isUser,
    this.text,
    this.post,
    this.imageLink,
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
    if (text == null) {
      if (post != null) {
        return _buildPostMessage(context);
      } else if (this.imageLink != null) {
        return _buildPhotoMessage(context);
      }
    }
    return _buildTextMessage(context);
  }

  Widget _buildTextMessage(BuildContext context) {
    return Text(
      this.text,
      style: isUser
          ? Theme.of(context).textTheme.bodyText1
          : Theme.of(context).textTheme.bodyText2,
    );
  }

  Widget _buildPhotoMessage(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25.0),
        child: Image(
          image: NetworkImage(this.imageLink),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildPostMessage(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25.0),
        child: Image(
          image: NetworkImage(this.post.postImageLink),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
