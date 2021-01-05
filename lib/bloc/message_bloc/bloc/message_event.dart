part of 'message_bloc.dart';

@immutable
abstract class MessageEvent {}

class GetMessage extends MessageEvent {}

class PostMessage extends MessageEvent {}
