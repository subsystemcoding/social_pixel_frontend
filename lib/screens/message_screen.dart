import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialpixel/bloc/message_bloc/bloc/message_bloc.dart';
import 'package:socialpixel/data/models/message.dart';
import 'package:socialpixel/widgets/app_bar.dart';
import 'package:socialpixel/widgets/message_box.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final messageBloc = BlocProvider.of<MessageBloc>(context);
    messageBloc.add(GetMessage());
    return Scaffold(
      backgroundColor: Color(0xffe5e5e5),
      appBar: MenuBar().messageAppBar(context,
          image: NetworkImage(
              "https://makersforgegames.com/wp-content/uploads/2019/09/IMG_1655-e1546884301904-963x770.jpg"),
          username: "Riya"),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<MessageBloc, MessageState>(
              builder: (context, state) {
                print(state);
                if (state is MessageLoaded) {
                  return buildMessageBoxes(context, state.messages);
                }
                return Container();
              },
            ),
          ),
          Container(
            height: 75.0,
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
        return MessageBox(
          isUser: message.userId == "001",
          text: message.messageBody,
        );
      },
    );
  }
}
