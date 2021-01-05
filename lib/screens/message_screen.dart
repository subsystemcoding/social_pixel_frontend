import 'package:flutter/material.dart';
import 'package:socialpixel/widgets/app_bar.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MenuBar().messageAppBar(context,
          image: NetworkImage(
              "https://makersforgegames.com/wp-content/uploads/2019/09/IMG_1655-e1546884301904-963x770.jpg"),
          username: "Riya"),
      body: Row(
        children: [
          Expanded(
            child: ListView.builder(),
          ),
          Container(
            height: 75.0,
          )
        ],
      ),
    );
  }
}
