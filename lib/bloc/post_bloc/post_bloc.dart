import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
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
    if (event is GetPost) {
      try {
        final posts = await postManagement.fetchPosts();
        yield PostLoaded(posts);
      } catch (e) {
        yield PostError("Could not find posts");
      }
    }
    // TODO: implement mapEventToState
  }
}
