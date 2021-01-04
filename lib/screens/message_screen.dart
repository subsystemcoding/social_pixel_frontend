import 'package:flutter/material.dart';
import 'package:socialpixel/widgets/app_bar.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MenuBar() as PreferredSizeWidget,
      body: Container(),
    );
  }
}
