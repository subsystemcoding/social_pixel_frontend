import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:socialpixel/data/models/game.dart';
import 'package:socialpixel/data/models/location.dart';
import 'package:socialpixel/data/models/mapPost.dart';
import 'package:socialpixel/data/models/post.dart';
import 'package:socialpixel/data/repos/map_repository.dart';
import 'package:socialpixel/data/repos/post_management.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapRepository _mapRepository = MapRepository();
  MapBloc() : super(MapInitial());

  @override
  Stream<MapState> mapEventToState(
    MapEvent event,
  ) async* {
    if (event is GetPosts) {
      var cachedPosts = await _mapRepository.fetchCachedPosts();
      if (cachedPosts.isNotEmpty) {
        yield MapPostLoaded(cachedPosts);
      }

      ///if not available due to internet
      ///show no internet connection snackbar
      ///If both are not available then
      ///connect to internet screen
      yield MapPostLoaded(
          await _mapRepository.fetchPostsByLocation(event.location));
    } else if (event is AddPostToChecklist) {
      await _mapRepository.addPostToChecklist(event.mapPost);

      yield MapPostInChecklist(
        await _mapRepository.hasPostinChecklist(event.mapPost),
      );
    } else if (event is RemovePostFromChecklist) {
      await _mapRepository.removePostFromChecklist(event.mapPost);
      yield MapPostInChecklist(
        await _mapRepository.hasPostinChecklist(event.mapPost),
      );
    } else if (event is CheckPostInChecklist) {
      yield MapPostInChecklist(
        await _mapRepository.hasPostinChecklist(event.mapPost),
      );
    } else if (event is GetPostsFromChecklist) {
      List<MapPost> mapPosts = await _mapRepository.getAllPostInChecklist();
      yield MapPostInChecklistLoaded(mapPosts);
    } else if (event is GetSubscribedGames) {
      List<Game> games = await _mapRepository.fetchSubscribedGames();
      yield SubscribedGamesLoaded(games);
    } else if (event is AddPostForValidation) {
      yield MapPostLoading();
      try {
        int postId = await PostManagement()
            .sendPost(event.post, event.post.postImageLink);
        await _mapRepository.addPostForValidation(event.originalPostId, postId);
        yield MapPostAddedForValidation();
      } catch (e) {
        print(e);
        yield MapPostError();
      }
    }
  }
}
