import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:socialpixel/data/models/chatroom.dart';
import 'package:socialpixel/data/models/game.dart';
import 'package:socialpixel/data/models/mapPost.dart';
import 'package:socialpixel/data/repos/channel_repository.dart';
import 'package:socialpixel/data/models/channel.dart';
import 'package:socialpixel/data/repos/game_repository.dart';
import 'package:socialpixel/data/repos/message_managament.dart';
import 'package:socialpixel/data/repos/post_management.dart';

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
        print(e);
        yield ChannelError("Channel does not exist");
      }
    } else if (event is GetChannelList) {
      try {
        final channelList = await channelRepository.fetchChannelList();
        yield ChannelListLoaded(channelList);
      } catch (e) {
        yield ChannelError("No channel found");
      }
    } else if (event is SearchChannel) {
      try {
        final channels =
            await channelRepository.fetchChannelsByName(event.name);
        yield ChannelListLoaded(channels);
      } catch (e) {
        yield ChannelError("No channel found");
      }
    } else if (event is StartChannelIniital) {
      yield ChannelInitial();
    } else if (event is SubscribeChannel) {
      try {
        await channelRepository.subscribeToChannel(
            event.channel.name, event.channel.isSubscribed);
        event.channel.isSubscribed = !event.channel.isSubscribed;
        if (event.channel.isSubscribed) {
          event.channel.subscribers++;
        } else {
          event.channel.subscribers--;
        }
        yield ChannelSubscribed();
      } catch (e) {
        yield ChannelSubscribedError();
      }
    } else if (event is CreateChannel) {
      bool roomCreated = true;
      bool gameCreated = true;

      try {
        //create channel
        Channel channel =
            await channelRepository.createChannel(channel: event.channel);

        //create chatrooms
        for (var chatroom in event.chatrooms) {
          try {
            await channelRepository.createChatroom(
              channel,
              chatroom.name,
            );
          } catch (e) {
            roomCreated = false;
          }
        }
        try {
          for (var game in event.games) {
            for (int i = 0; i < game.mapPosts.length; i++) {
              await PostManagement().sendPost(
                game.mapPosts[i].post,
                game.mapPosts[i].post.postImageLink,
              );
            }
            await GameRepository().createGame(
              channel.name,
              game.name,
              game.description,
              game.image,
              List<int>.from(
                game.mapPosts.map((mapPost) => mapPost.post.postId),
              ),
            );
          }
        } catch (e) {
          print(e);
        }
        yield ChannelCreated(channel.id, roomCreated, gameCreated);
      } catch (e) {
        print(e);
        yield ChannelError("");
      }
    }
  }
}
