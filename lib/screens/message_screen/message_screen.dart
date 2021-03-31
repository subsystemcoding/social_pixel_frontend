import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'package:socialpixel/bloc/message_bloc/bloc/message_bloc.dart';
import 'package:socialpixel/data/debug_mode.dart';
import 'package:socialpixel/data/models/chatroom.dart';
import 'package:socialpixel/data/models/message.dart';
import 'package:socialpixel/data/models/post.dart';
import 'package:socialpixel/data/repos/auth_repository.dart';
import 'package:socialpixel/data/repos/message_managament.dart';
import 'package:socialpixel/widgets/app_bar.dart';
import 'package:socialpixel/widgets/message_box.dart';

class MessageScreen extends StatefulWidget {
  final Chatroom chatroom;
  const MessageScreen({
    Key key,
    this.chatroom,
  }) : super(key: key);

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  Timer timer;
  Chatroom chatroom;
  String currentUsername;
  Icon textButtonIcon;
  Function onPressed;
  bool textEmpty = true;
  TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    AuthRepository().getAuth().then((authObject) {
      currentUsername = authObject.username;
      timer = Timer.periodic(
          Duration(seconds: 1),
          (t) => BlocProvider.of<MessageBloc>(context)
              .add(GetChat(widget.chatroom.id)));
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    textButtonIcon = Icon(
      Icons.camera_alt_outlined,
      color: Theme.of(context).primaryColor,
    );
    onPressed = () {
      // TODO
      MessageManagement().setCurrentChatroom(chatroom);
      Navigator.of(context).pushNamed("/camera", arguments: {
        'route': '/preview_screen',
        'isSquare': false,
      });
    };
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
        } else if (state is MessageLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return chatroom == null
            ? Container()
            : _buildScaffold(context, chatroom);
      },
    );
  }

  Widget _buildScaffold(BuildContext context, Chatroom chatroom) {
    // TODO
    return Scaffold(
      backgroundColor: Color(0xffe5e5e5),
      appBar: MenuBar().messageAppBar(context,
          image: NetworkImage(chatroom.userImage),
          username: widget.chatroom.name),
      body: Column(
        children: [
          Expanded(
            child: buildMessageBoxes(context, chatroom.messages),
          ),
          Container(
            height: 45.0,
            margin: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                      border: InputBorder.none,
                      hintText: "Type a message",
                      hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    onChanged: (val) {
                      if (val.isNotEmpty && textEmpty) {
                        setState(() {
                          textEmpty = false;
                          textButtonIcon = Icon(
                            Icons.send,
                            color: Theme.of(context).primaryColor,
                          );
                          onPressed = () {
                            BlocProvider.of<MessageBloc>(context).add(
                              PostMessage(
                                Message(
                                  text: _controller.text,
                                ),
                                chatroom.id,
                              ),
                            );
                            print(val);

                            setState(() {
                              _controller.clear();
                            });
                          };
                        });
                      } else if (val.isEmpty && !textEmpty) {
                        setState(() {
                          textEmpty = true;
                          textButtonIcon = Icon(
                            Icons.camera_alt_outlined,
                            color: Theme.of(context).primaryColor,
                          );
                          onPressed = () {
                            Navigator.of(context).pushNamed("/camera",
                                arguments: "/preview_screen");
                          };
                        });
                      }
                    },
                  ),
                ),
                Container(
                  width: 47,
                  margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                  child: TextButton(
                    child: textButtonIcon,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 0.0),
                      elevation: 2,
                      backgroundColor: Theme.of(context).accentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(25.0),
                        ),
                      ),
                    ),
                    onPressed: onPressed,
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
        Message message = messages[index];
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
