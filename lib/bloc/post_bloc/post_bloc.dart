import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:image/image.dart' as imageLib;
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';
import 'package:socialpixel/data/models/game.dart';
import 'package:socialpixel/data/models/location.dart';
import 'package:socialpixel/data/models/post.dart';
import 'package:socialpixel/data/repos/post_management.dart';
import 'package:exif/exif.dart';

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
      if (event is FetchInitialPost) {
        yield PostLoaded(await postManagement.fetchCachedPosts());

        ///if not available due to internet
        ///show no internet connection snackbar
        ///If both are not available then
        ///connect to internet screen
        yield PostLoaded(await postManagement.fetchOnlinePosts());
      } else if (event is FetchMorePost) {
        yield PostLoaded(await postManagement.fetchOnlinePosts());
      } else if (event is FetchNewPost) {
        /// if no new post available then show snack bar
        yield PostLoaded(await postManagement.fetchOnlinePosts());
      } else if (event is FetchSearchedPost) {
        /// Return searched posts with hashtags
        yield PostLoaded(await postManagement.fetchOnlinePosts());
      } else if (event is FetchProfilePost) {
        /// Return posts that are under user profile
        yield PostLoaded(await postManagement.fetchOnlinePosts());
      } else if (event is GetPostAndGame) {
        final posts = await postManagement.fetchOnlinePosts();
        yield PostLoaded(posts);
        final games = await postManagement.fetchGamePosts();
        yield GamePostLoaded(games);
      } else if (event is GetGame) {
        final games = await postManagement.fetchGamePosts();
        yield GamePostLoaded(games);
      } else if (event is SendPost) {
        //await postManagement.sendPost(post, PostSending.Successful);
        // TODO
        yield PostSent(PostSending.Successful);
      }
    } catch (e) {
      print(e);
      yield PostError("Could not find posts");
    }
    // TODO: implement mapEventToState
  }
}
