import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:socialpixel/data/models/game.dart';
import 'package:socialpixel/data/repos/post_management.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  PostManagement postManagement = PostManagement();
  GameBloc() : super(GameInitial());

  @override
  Stream<GameState> mapEventToState(
    GameEvent event,
  ) async* {
    yield GameLoading();
    try {
      if (event is FetchGames) {
        yield GameLoaded(
            await postManagement.fetchGamePosts(channelId: event.channelId));
      }
    } catch (e) {
      yield GameError("error");
    }
    // TODO: implement mapEventToState
  }
}
