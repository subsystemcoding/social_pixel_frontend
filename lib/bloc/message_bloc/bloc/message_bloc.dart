import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:socialpixel/bloc/channel_bloc/channel_bloc.dart';
import 'package:socialpixel/data/models/chatroom.dart';
import 'package:socialpixel/data/repos/message_managament.dart';
import 'package:socialpixel/data/models/message.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  MessageManagement messageManagement = MessageManagement();
  MessageBloc() : super(MessageInitial());

  @override
  Stream<MessageState> mapEventToState(
    MessageEvent event,
  ) async* {
    yield MessageLoading();
    if (event is GetAllChats) {
      List<Chatroom> chatrooms = await messageManagement.getAllChatrooms();
      yield ChatroomLoadedAll(chatrooms);
    } else if (event is GetChat) {
      Chatroom chatroom = await messageManagement.getChatroom(event.chatroomId);
      yield ChatroomLoaded(chatroom);
    } else if (event is PostMessage) {
      var result = await messageManagement.sendMessage(
          chatroomId: event.chatroomId, message: event.message);
      if (result) {
        yield MessageSent();
      } else {
        yield MessageSendError();
      }
    } else if (event is GetNewMessage) {
      int newMessages = await messageManagement.getNumOfNewMessages();
      yield NewMessages(newMessages);
    }
  }
}
