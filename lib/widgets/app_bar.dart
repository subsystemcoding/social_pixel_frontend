import 'package:flutter/material.dart';
import 'package:socialpixel/widgets/tabbar.dart';

class MenuBar {
  //final AppBar

  Widget appbar(BuildContext context, {String title = "Home"}) {
    return AppBar(
        toolbarHeight: 85.0,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Padding(
            padding: const EdgeInsets.only(top: 30.0, bottom: 10.0),
            child: Row(
              children: [
                Icon(
                  Icons.menu,
                  color: Colors.black,
                  size: 40.0,
                ),
                SizedBox(
                  width: 12.0,
                ),
                Text(
                  title,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).primaryTextTheme.headline1,
                ),
              ],
            )));
  }

  /* Widget titleBar(BuildContext context, {String title = "Home"}) {
    return Container(
        padding: const EdgeInsets.only(top: 50.0, left: 24.0),
        child: Row(
          children: [
            GestureDetector(
              child: Icon(
                Icons.menu,
                color: Colors.black,
                size: 40.0,
              ),
              onTap: () {},
            ),
            SizedBox(
              width: 12.0,
            ),
            Text(
              title,
              textAlign: TextAlign.left,
              style: Theme.of(context).primaryTextTheme.headline1,
            ),
          ],
        ));
  }   */

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
