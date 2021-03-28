import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialpixel/bloc/message_bloc/bloc/message_bloc.dart';
import 'package:socialpixel/data/Converter.dart';
import 'package:socialpixel/data/debug_mode.dart';
import 'package:socialpixel/data/models/chatroom.dart';
import 'package:socialpixel/data/models/message.dart';
import 'package:socialpixel/widgets/app_bar.dart';
import 'package:socialpixel/widgets/bottom_nav_bar.dart';
import 'package:socialpixel/widgets/custom_drawer.dart';
import 'package:socialpixel/widgets/search_bar.dart';

class MessageListScreen extends StatefulWidget {
  const MessageListScreen({Key key}) : super(key: key);

  @override
  _MessageListScreenState createState() => _MessageListScreenState();
}

class _MessageListScreenState extends State<MessageListScreen> {
  Timer timer;
  bool debug = true;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1),
        (t) => BlocProvider.of<MessageBloc>(context).add(GetAllChats()));
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Chatroom> chatrooms = [];
    return Scaffold(
      appBar: MenuBar().appbar,
      drawer: CustomDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MenuBar().titleBar(context, title: "Messages"),
          SizedBox(height: 16.0),
          SearchBar(),
          SizedBox(height: 24.0),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 12.0),
              child: BlocBuilder<MessageBloc, MessageState>(
                builder: (context, state) {
                  if (state is ChatroomLoadedAll) {
                    chatrooms = state.chatrooms;
                  }
                  return ListView.builder(
                    itemCount: chatrooms.length * 2,
                    itemBuilder: (BuildContext context, int index) {
                      int i = index ~/ 2;
                      if (index % 2 == 0) {
                        String text;
                        Message message = chatrooms[i].messages[0];
                        if (message.text != null) {
                          text = message.text;
                        } else if (message.post != null) {
                          text = "*Post*";
                        } else if (message.imageLink != null) {
                          text = "*Image*";
                        }
                        return buildUserLists(
                          context,
                          chatroom: chatrooms[i],
                          text: text,
                          imageLink: message.userImage,
                          time: Converter.dateTimeStringtoReadable(
                              message.createDate),
                          notification: chatrooms[i].newMessages,
                        );
                      } else {
                        return Container(
                          margin: EdgeInsets.only(bottom: 12.0),
                          child: Divider(
                            indent: 92.0,
                            endIndent: 16.0,
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentRoute: '/message_list',
      ),
    );
  }

  Widget buildUserLists(
    BuildContext context, {
    Chatroom chatroom,
    String text,
    String imageLink,
    String time,
    int notification,
  }) {
    var backgroundImage;
    if (imageLink != '' && imageLink != null) {
      backgroundImage = NetworkImage(imageLink);
    }
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: backgroundImage,
        backgroundColor: Theme.of(context).accentColor.withAlpha(60),
        radius: 30,
      ),
      title: Text(chatroom.name),
      subtitle: Text(text),
      trailing: SizedBox(
        height: 50,
        width: 50,
        child: Column(
          children: [
            SizedBox(
              height: 8,
            ),
            Text(
              time,
              style: Theme.of(context).primaryTextTheme.subtitle1,
            ),
            SizedBox(
              height: notification > 0 ? 4 : 0,
            ),
            notification > 0
                ? Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(25.0),
                      ),
                    ),
                    padding:
                        EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
                    child: Text(
                      notification.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
      onTap: () {
        Navigator.of(context).pushNamed('/message', arguments: chatroom);
      },
    );
  }
}
