import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:socialpixel/bloc/message_bloc/bloc/message_bloc.dart';
import 'package:socialpixel/data/models/chatroom.dart';
import 'package:socialpixel/data/models/message.dart';
import 'package:socialpixel/data/models/post.dart';
import 'package:socialpixel/data/repos/auth_repository.dart';
import 'package:socialpixel/widgets/app_bar.dart';
import 'package:socialpixel/widgets/message_box.dart';

class MessageScreen extends StatefulWidget {
  final int chatroomId;
  final String name;
  final String imageLink;
  const MessageScreen({
    Key key,
    this.chatroomId,
    this.name,
    this.imageLink,
  }) : super(key: key);

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  Timer timer;
  Chatroom chatroom;
  String currentUsername;

  @override
  void initState() async {
    super.initState();
    final authObject = await AuthRepository().getAuth();
    currentUsername = authObject.username;
    timer = Timer.periodic(
        Duration(seconds: 1),
        (t) => BlocProvider.of<MessageBloc>(context)
            .add(GetChat(widget.chatroomId)));
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessageBloc, MessageState>(
      builder: (context, state) {
        if (state is ChatroomLoaded) {
          chatroom = state.chatroom;
        }
        return chatroom == null
            ? Container()
            : _buildScaffold(context, chatroom);
      },
    );
  }

  Widget _buildScaffold(BuildContext context, Chatroom chatroom) {
    return Scaffold(
      backgroundColor: Color(0xffe5e5e5),
      appBar: MenuBar().messageAppBar(context,
          image: NetworkImage(widget.imageLink), username: widget.name),
      body: Column(
        children: [
          Expanded(
            child: buildMessageBoxes(context, chatroom.messages),
          ),
          Container(
            height: 60.0,
            margin: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                      border: InputBorder.none,
                      hintText: "Type a message",
                      hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                ),
                Container(
                  width: 60,
                  height: 50,
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextButton(
                    child: Icon(
                      Icons.arrow_back,
                      color: Theme.of(context).primaryColor,
                    ),
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 0.0),
                        elevation: 2,
                        backgroundColor: Theme.of(context).accentColor,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)))),
                    onPressed: () {},
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildMessageBoxes(BuildContext context, List<Message> messages) {
    return ListView.builder(
      reverse: true,
      itemCount: messages.length,
      itemBuilder: (BuildContext context, int index) {
        Message message = messages[messages.length - 1 - index];
        String text = message.text;
        Post post = message.post;
        String imageLink = message.imageLink;
        return MessageBox(
          isUser: message.username == currentUsername,
          text: message.text,
          post: message.post,
          imageLink: message.imageLink,
        );
      },
    );
  }
}
