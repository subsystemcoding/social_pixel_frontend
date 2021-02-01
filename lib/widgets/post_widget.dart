import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:socialpixel/data/models/location.dart';

class PostWidget extends StatelessWidget {
  final String userName;
  final String userAvatar;
  final String datePosted;
  final String postImage;
  final String caption;
  final List<String> otherUsers;
  final int upvotes;
  final int comments;
  final Location location;
  final Uint8List userAvatarBytes;
  final Uint8List postImageBytes;
  final List<Uint8List> otherUsersBytes;

  const PostWidget({
    Key key,
    this.userAvatar,
    this.datePosted,
    this.postImage,
    this.otherUsers,
    this.caption,
    this.userName,
    this.upvotes,
    this.comments,
    this.location,
    this.userAvatarBytes,
    this.postImageBytes,
    this.otherUsersBytes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 24.0, horizontal: 28.0),
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(25.0),
        boxShadow: [
          BoxShadow(
              blurRadius: 10.0,
              color: Colors.grey[300],
              offset: Offset(0.5, 0.5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          profile(context),
          SizedBox(
            height: 12.0,
          ),
          post(),
          SizedBox(
            height: 12.0,
          ),
          getGpsTag(text: this.location.toString()),
          getCaption(context),
          SizedBox(
            height: 12.0,
          ),
          buttons(context),
          SizedBox(
            height: 12.0,
          ),
          information(context),
          SizedBox(
            height: 12.0,
          ),
        ],
      ),
    );
  }

  Widget profile(BuildContext context) {
    print(this.userAvatar);
    return Row(children: [
      CircleAvatar(
        backgroundImage: this.userAvatarBytes != null
            ? MemoryImage(this.userAvatarBytes)
            : NetworkImage(this.userAvatar),
        radius: 30,
      ),
      SizedBox(
        width: 12.0,
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              this.userName,
              textAlign: TextAlign.left,
              style: Theme.of(context).primaryTextTheme.headline4,
            ),
            Text(
              datePosted,
              textAlign: TextAlign.left,
              style: Theme.of(context).primaryTextTheme.subtitle1,
            )
          ],
        ),
      ),
    ]);
  }

  Widget post() {
    print(this.postImageBytes.toString());
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 300.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25.0),
        child: Image(
          image: this.postImageBytes != null
              ? MemoryImage(this.postImageBytes)
              : NetworkImage(this.postImage),
          fit: BoxFit.scaleDown,
        ),
      ),
    );
  }

  Widget getCaption(BuildContext context) {
    return Container(
      child: Text(
        this.caption,
        textAlign: TextAlign.left,
        style: Theme.of(context).primaryTextTheme.bodyText1,
      ),
    );
  }

  Widget buttons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        button(context,
            text: "Upvote",
            onPressed: () => {},
            textStyle: Theme.of(context).textTheme.bodyText1,
            backgroundColor: Theme.of(context).accentColor),
        button(context,
            text: "Comment",
            onPressed: () => {},
            textStyle: Theme.of(context).textTheme.bodyText2,
            backgroundColor: Theme.of(context).disabledColor),
        button(context,
            text: "Share",
            onPressed: () => {},
            textStyle: Theme.of(context).textTheme.bodyText2,
            backgroundColor: Theme.of(context).disabledColor),
      ],
    );
  }

  Widget button(BuildContext context,
      {String text,
      Function onPressed,
      TextStyle textStyle,
      Color backgroundColor}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0.0),
      child: TextButton(
        child: Text(
          text,
          style: textStyle,
        ),
        style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0))),
        onPressed: onPressed,
      ),
    );
  }

  Widget information(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 120,
          height: 45,
          child: getavatars(context,
              images: this.otherUsersBytes == null
                  ? this.otherUsers
                  : this.otherUsersBytes,
              radius: 20),
        ),
        Text(
          this.upvotes.toString() + " " + this.comments.toString() ?? '',
          style: Theme.of(context).primaryTextTheme.subtitle1,
        )
      ],
    );
  }

  Widget getavatars(BuildContext context, {images, double radius}) {
    List<Widget> children = List<Widget>();
    for (var i = 0; i < images.length; i++) {
      children.add(Positioned(
        left: i * radius,
        child: CircleAvatar(
          backgroundColor: Theme.of(context).accentColor,
          child: CircleAvatar(
            backgroundImage: images[i] is String
                ? NetworkImage(images[i])
                : MemoryImage(images[i]),
            radius: radius - 3,
          ),
        ),
      ));
    }
    return Stack(
      clipBehavior: Clip.none,
      children: children,
    );
  }

  Widget getGpsTag({String text}) {
    return Container(
      height: 50,
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Icon(Icons.location_pin, color: Colors.blue),
          SizedBox(
            width: 4,
          ),
          Text(
            text,
            style: TextStyle(fontSize: 16.0, color: Colors.blue),
          )
        ],
      ),
    );
  }
}
