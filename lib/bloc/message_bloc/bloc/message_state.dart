part of 'message_bloc.dart';

@immutable
abstract class MessageState {}

class MessageInitial extends MessageState {}

class MessageLoading extends MessageState {
  MessageLoading();
}

class ChatroomLoadedAll extends MessageState {
  final List<Chatroom> chatrooms;

  ChatroomLoadedAll(this.chatrooms);
}

class ChatroomLoaded extends MessageState {
  final Chatroom chatroom;

  ChatroomLoaded(this.chatroom);
}

class NewMessages extends MessageState {
  final int messages;

  NewMessages(this.messages);
}

class MessageSent extends MessageState {}

class MessageSendError extends MessageState {}
