part of 'channel_bloc.dart';

@immutable
abstract class ChannelState {}

class ChannelInitial extends ChannelState {}

class ChannelLoaded extends ChannelState {
  final Channel channel;

  ChannelLoaded(this.channel);
}

class ChannelLoading extends ChannelState {}

class ChannelListLoaded extends ChannelState {
  final List<Channel> channels;

  ChannelListLoaded(this.channels);
}

class ChannelSubscribed extends ChannelState {}

class ChannelSubscribedError extends ChannelState {}

class ChannelError extends ChannelState {
  final String message;

  ChannelError(this.message);
}
