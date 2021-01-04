import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(Icons.home_outlined, color: Colors.white),
          Icon(Icons.search_outlined, color: Colors.white),
          Icon(Icons.add, color: Colors.white),
          Icon(Icons.map_outlined, color: Colors.white),
          Icon(Icons.message_outlined, color: Colors.white),
          Icon(Icons.notifications_outlined, color: Colors.white)
        ],
      ),
    );
  }
}
