import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:socialpixel/data/repos/channel_repository.dart';
import 'package:socialpixel/data/models/channel.dart';

part 'channel_event.dart';
part 'channel_state.dart';

class ChannelBloc extends Bloc<ChannelEvent, ChannelState> {
  ChannelRepository channelRepository = ChannelRepository();
  ChannelBloc() : super(ChannelInitial());

  @override
  Stream<ChannelState> mapEventToState(
    ChannelEvent event,
  ) async* {
    yield ChannelLoading();
    if (event is GetChannel) {
      try {
        final channel = await channelRepository.fetchChannel(event.channelId);
        yield ChannelLoaded(channel);
      } catch (e) {
        yield ChannelError("Channel does not exist");
      }
    } else if (event is GetChannelList) {
      try {
        final channelList = await channelRepository.fetchChannelList();
        yield ChannelListLoaded(channelList);
      } catch (e) {
        yield ChannelError("No channel found");
      }
    }
    // TODO: implement mapEventToState
  }
}
