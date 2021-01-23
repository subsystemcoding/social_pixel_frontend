import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:socialpixel/data/models/game.dart';
import 'package:socialpixel/data/models/post.dart';
import 'package:socialpixel/data/post_management.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final postManagement = PostManagement();

  PostBloc() : super(PostInitial());

  @override
  Stream<PostState> mapEventToState(
    PostEvent event,
  ) async* {
    yield PostLoading();

    try {
      if (event is GetPost) {
        final posts = await postManagement.fetchPosts();
        yield PostLoaded(posts);
      } else if (event is GetPostAndGame) {
        final posts = await postManagement.fetchPosts();
        yield PostLoaded(posts);
        final games = await postManagement.fetchGamePosts();
        yield GamePostLoaded(games);
      } else if (event is GetGame) {
        final games = await postManagement.fetchGamePosts();
        yield GamePostLoaded(games);
      } else if (event is SendPost) {
        final value =
            await postManagement.sendPost(event.post, PostSending.Successful);
        yield PostSent(value);
      }
    } catch (e) {
      yield PostError("Could not find posts");
    }
    // TODO: implement mapEventToState
  }
}
