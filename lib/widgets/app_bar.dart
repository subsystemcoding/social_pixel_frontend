import 'package:flutter/material.dart';

class MenuBar {
  final AppBar transparentAppBar = AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
  );

  final AppBar appbar = AppBar(
    toolbarHeight: 75.0,
    backgroundColor: Colors.transparent,
    elevation: 0,
    // leading: Padding(
    //   padding: const EdgeInsets.only(top: 24.0, left: 24.0),
    //   child: GestureDetector(
    //     onTap: () {
    //       final scaffoldState = ScaffoldState();
    //       if (scaffoldState.isDrawerOpen) {
    //         Navigator.pop(scaffoldState.context);
    //       } else {
    //         scaffoldState.openDrawer();
    //       }
    //     },
    //     child: Icon(
    //       Icons.menu,
    //       color: Colors.black,
    //       size: 40.0,
    //     ),
    //   ),
    // ),
  );

  Widget titleBar(BuildContext context, {String title = "Home"}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 28.0),
      child: Text(
        title,
        textAlign: TextAlign.left,
        style: Theme.of(context).primaryTextTheme.headline1,
      ),
    );
  }

  AppBar messageAppBar(BuildContext context,
      {ImageProvider<Object> image, String username}) {
    return AppBar(
      toolbarHeight: 100.0,
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.only(top: 24.0, left: 24.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).accentColor,
              child: CircleAvatar(
                backgroundColor: Theme.of(context).accentColor.withAlpha(60),
                backgroundImage: image,
                radius: 25,
              ),
            ),
            SizedBox(
              width: 24.0,
            ),
            Text(
              username,
              style: Theme.of(context).primaryTextTheme.headline2,
            ),
          ],
        ),
      ),
    );
  }
}
