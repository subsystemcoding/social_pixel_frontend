import 'package:flutter/material.dart';

class MenuBar extends StatelessWidget {
  const MenuBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 75.0,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.only(top: 24.0, left: 24.0),
        child: Icon(
          Icons.menu,
          color: Colors.black,
          size: 40.0,
        ),
      ),
    );
  }
}
