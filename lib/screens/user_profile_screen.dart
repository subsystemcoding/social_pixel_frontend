import 'package:flutter/material.dart';
import 'package:tinycolor/tinycolor.dart';

class UserProfileScreen extends StatelessWidget {
  final ImageProvider<Object> coverImage;
  final ImageProvider<Object> avatarImage;
  final String userName;
  final String description;
  final bool isVerified;
  final String points;
  final String followers;
  final bool isUser;
  const UserProfileScreen({
    Key key,
    this.coverImage,
    this.avatarImage,
    this.userName,
    this.description,
    this.isVerified = true,
    this.points = '0',
    this.followers,
    this.isUser = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Center(
          child: NestedScrollView(
            headerSliverBuilder: (context, bool) {
              return [
                SliverAppBar(
                  expandedHeight: 200,
                  flexibleSpace: buildImages(context),
                ),
              ];
            },
            body: Column(
              children: [
                buildInfo(context),
                SizedBox(
                  height: 12.0,
                ),
                buildButtons(context),
                SizedBox(
                  height: 12.0,
                ),
                buildPosts(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildImages(BuildContext context) {
    double radius = 50;
    double coverImageHeight = 150;
    return Container(
      height: 200,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            child: Image(
              height: coverImageHeight,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
              image: this.coverImage,
              color: Color(0x66000000),
              colorBlendMode: BlendMode.darken,
            ),
          ),
          Positioned(
            top: coverImageHeight - radius,
            left: MediaQuery.of(context).size.width / 2 - radius,
            child: CircleAvatar(
              backgroundImage: this.avatarImage,
              radius: radius,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              this.userName,
              style: Theme.of(context).primaryTextTheme.headline3,
            ),
            SizedBox(
              width: isVerified ? 16 : 0,
            ),
            isVerified
                ? Container(
                    margin: EdgeInsets.only(bottom: 8.0),
                    padding:
                        EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: TinyColor(Theme.of(context).accentColor)
                          .lighten(35)
                          .color,
                      borderRadius: BorderRadius.all(
                        Radius.circular(12.0),
                      ),
                    ),
                    child: Text(
                      "Verified",
                      style: TextStyle(
                          fontSize: 16.0,
                          color: TinyColor(Theme.of(context).accentColor)
                              .lighten(0)
                              .color),
                    ),
                  )
                : Container(),
          ],
        ),
        SizedBox(
          height: 12.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(points, style: Theme.of(context).primaryTextTheme.headline4),
            Text(" points • ",
                style: Theme.of(context).primaryTextTheme.subtitle2),
            Text(followers,
                style: Theme.of(context).primaryTextTheme.headline4),
            Text(" followers",
                style: Theme.of(context).primaryTextTheme.subtitle2),
          ],
        ),
      ],
    );
  }

  Widget buildButtons(BuildContext context) {
    List<Widget> buttons = isUser
        ? [
            buildButton(
              context,
              "Edit Profile",
              primaryColor:
                  TinyColor(Theme.of(context).accentColor).lighten(10).color,
              backgroundColor:
                  TinyColor(Theme.of(context).accentColor).lighten(38).color,
            ),
            buildButton(context, "Stats"),
          ]
        : [
            buildButton(context, "Follow"),
            buildButton(context, "Message"),
            buildButton(context, "Stats"),
          ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 28.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        //mainAxisSize: MainAxisSize.min,
        children: buttons,
      ),
    );
  }

  Widget buildButton(BuildContext context, String text,
      {Color primaryColor, Color backgroundColor}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          primary: primaryColor ?? Theme.of(context).primaryColor,
          backgroundColor: backgroundColor ?? Theme.of(context).accentColor,
          textStyle: Theme.of(context).primaryTextTheme.subtitle1,
          minimumSize: Size(100, 0),
          //padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        child: Text(
          text,
        ),
      ),
    );
  }

  Widget buildPosts(context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 28.0, vertical: 8.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "Pictures Posted",
          style: Theme.of(context).primaryTextTheme.headline4,
        ),
        SizedBox(
          height: 8.0,
        ),
        buildPostsRow(),
        buildPostsRow(),
      ]),
    );
  }

  Widget buildPostsRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        buildPostImage(
          NetworkImage(
              "https://i.pinimg.com/originals/5b/b4/8b/5bb48b07fa6e3840bb3afa2bc821b882.jpg"),
        ),
        buildPostImage(
          NetworkImage(
              "https://i.pinimg.com/originals/5b/b4/8b/5bb48b07fa6e3840bb3afa2bc821b882.jpg"),
        ),
        buildPostImage(
          NetworkImage(
              "https://i.pinimg.com/originals/5b/b4/8b/5bb48b07fa6e3840bb3afa2bc821b882.jpg"),
        ),
      ],
    );
  }

  Widget buildPostImage(ImageProvider<Object> image) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Image(
            fit: BoxFit.cover,
            image: image,
          ),
        ),
      ),
    );
  }
}
