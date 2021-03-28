import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialpixel/bloc/message_bloc/bloc/message_bloc.dart';
import 'package:socialpixel/data/models/chatroom.dart';
import 'package:socialpixel/data/models/message.dart';
import 'package:socialpixel/data/repos/message_managament.dart';

class PreviewMessageScreen extends StatelessWidget {
  final String imageFilePath;
  const PreviewMessageScreen({Key key, this.imageFilePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Preview",
          style: Theme.of(context).primaryTextTheme.headline4,
        ),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Image.file(
            File(imageFilePath),
            fit: BoxFit.scaleDown,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(
          Icons.send,
          color: Theme.of(context).accentColor,
        ),
        onPressed: () {
          Chatroom chat = MessageManagement().getCurrentChatroom();
          BlocProvider.of<MessageBloc>(context).add(
            PostMessage(
              Message(
                imageLink: imageFilePath,
              ),
              chat.id,
            ),
          );
          Navigator.of(context).pushNamed('/message', arguments: chat);
        },
      ),
    );
  }
}
