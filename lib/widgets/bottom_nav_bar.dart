import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final String currentRoute;
  const BottomNavBar({
    Key key,
    this.currentRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50.0), topRight: Radius.circular(50.0))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            child: Icon(
              Icons.home_outlined,
              color: Colors.white,
              size: 28,
            ),
            onTap: () {
              if (currentRoute != '/home') {
                Navigator.of(context).pushNamed('/home');
              }
            },
          ),
          GestureDetector(
            child: Icon(
              Icons.search_outlined,
              color: Colors.white,
              size: 28,
            ),
            onTap: () {
              if (currentRoute != '/search') {
                Navigator.of(context).pushNamed('/search');
              }
            },
          ),
          GestureDetector(
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 28,
            ),
            onTap: () {
              Navigator.of(context).pushNamed('/camera', arguments: {
                'route': "/post_preview",
                'isSquare': true,
              });
              // if (currentRoute != '/post') {
              //   Navigator.of(context).pushNamed('/post');
              // }
            },
          ),
          GestureDetector(
            child: Icon(
              Icons.map_outlined,
              color: Colors.white,
              size: 28,
            ),
            onTap: () {
              // if (currentRoute != '/map') {
              //   Navigator.of(context).pushNamed('/map');
              // }
            },
          ),
          GestureDetector(
            child: Icon(
              Icons.message_outlined,
              color: Colors.white,
              size: 28,
            ),
            onTap: () {
              if (currentRoute != '/message_list') {
                Navigator.of(context).pushNamed('/message_list');
              }
            },
          ),
          GestureDetector(
            child: Icon(
              Icons.notifications_outlined,
              color: Colors.white,
              size: 28,
            ),
            onTap: () {
              // if (currentRoute != '/notification') {
              //   Navigator.of(context).pushNamed('/notification');
              // }
            },
          ),
        ],
      ),
    );
  }
}
