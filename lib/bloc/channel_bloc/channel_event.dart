part of 'channel_bloc.dart';

@immutable
abstract class ChannelEvent {}

class StartChannelIniital extends ChannelEvent {}

class GetChannelList extends ChannelEvent {}

class SearchChannel extends ChannelEvent {
  final String name;

  SearchChannel(this.name);
}

class GetChannel extends ChannelEvent {
  final int channelId;

  GetChannel(this.channelId);
}

class SubscribeChannel extends ChannelEvent {
  final Channel channel;

  SubscribeChannel(this.channel);
}

class CreateChannel extends ChannelEvent {
  final Channel channel;
  final List<String> chatrooms;
  final List<Game> games;

  CreateChannel(this.channel, this.chatrooms, this.games);
}
