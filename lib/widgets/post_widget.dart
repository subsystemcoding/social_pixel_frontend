import 'package:flutter/material.dart';

class PostWidget extends StatelessWidget {
  final String userName;
  final ImageProvider<Object> userAvatar;
  final String datePosted;
  final ImageProvider<Object> postImage;
  final String caption;
  final List<ImageProvider<Object>> otherUsers;
  final String status;

  const PostWidget({
    Key key,
    this.userAvatar,
    this.datePosted,
    this.postImage,
    this.otherUsers,
    this.status,
    this.caption,
    this.userName,
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
    return Row(children: [
      CircleAvatar(
        backgroundImage: this.userAvatar,
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
              style: Theme.of(context).primaryTextTheme.headline2,
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
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 300.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25.0),
        child: Image(
          image: this.postImage,
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
          child: getavatars(context, images: this.otherUsers, radius: 20),
        ),
        Text(
          this.status,
          style: Theme.of(context).primaryTextTheme.subtitle1,
        )
      ],
    );
  }

  Widget getavatars(BuildContext context,
      {List<ImageProvider<Object>> images, double radius}) {
    List<Widget> children = List<Widget>();
    for (var i = 0; i < images.length; i++) {
      children.add(Positioned(
        left: i * radius,
        child: CircleAvatar(
          backgroundColor: Theme.of(context).accentColor,
          child: CircleAvatar(
            backgroundImage: images[i],
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
}
