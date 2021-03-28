part of 'message_bloc.dart';

@immutable
abstract class MessageEvent {}

class GetAllChats extends MessageEvent {}

class GetChat extends MessageEvent {
  final int chatroomId;

  GetChat(this.chatroomId);
}

class GetNewMessage extends MessageEvent {
  final int newMessages;

  GetNewMessage(this.newMessages);
}

class PostMessage extends MessageEvent {
  final int chatroomId;
  final Message message;

  PostMessage(this.message, this.chatroomId);
}
