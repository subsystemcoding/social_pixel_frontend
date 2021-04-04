import 'dart:async';

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
        final channel = await channelRepository.fetchChannelsByName(event.name);
        yield ChannelListLoaded([channel]);
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
        int channelId = int.parse(
            await channelRepository.createChannel(channel: event.channel));

        //create chatrooms
        for (var name in event.chatrooms) {
          try {
            await channelRepository.createChatroom(
              event.channel,
              name,
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
              event.channel.name,
              game.description,
              game.image,
              game.mapPosts.map((mapPost) => mapPost.post.postId).toList(),
            );
          }
        } catch (e) {
          print(e);
        }
        yield ChannelCreated(channelId, roomCreated, gameCreated);
      } catch (e) {
        print(e);
        yield ChannelError("Create Channel");
      }
    } else if (event is GetTemp) {
      var games = channelRepository.getGamesFromTemp();
      var rooms = channelRepository.getRoomsFromTemp();
      yield ChannelGamesAndRooms(
        games: games,
        rooms: rooms,
      );
    } else if (event is AddGameToTemp) {
      channelRepository.addGameToTemp(event.game);
    } else if (event is AddChatroomToTemp) {
      channelRepository.addRoomToTemp(event.chat);
    } else if (event is ClearTemp) {
      channelRepository.clearTemp();
    }
  }
}
