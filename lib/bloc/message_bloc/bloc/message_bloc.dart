import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:socialpixel/data/message_managament.dart';
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
    if (event is GetMessage) {
      List<Message> messages = await messageManagement.fetchMessages();
      yield MessageLoaded(messages);
    } else if (event is PostMessage) {
      yield MessageSent();
    }
    // TODO: implement mapEventToState
  }
}
