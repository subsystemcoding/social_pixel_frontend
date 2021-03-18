part of 'map_bloc.dart';

@immutable
abstract class MapEvent {}

class GetPosts extends MapEvent {}

class AddPostToChecklist extends MapEvent {
  final MapPost mapPost;

  AddPostToChecklist(this.mapPost);
}

class RemovePostFromChecklist extends MapEvent {
  final MapPost mapPost;

  RemovePostFromChecklist(this.mapPost);
}

class CheckPostInChecklist extends MapEvent {
  final MapPost mapPost;

  CheckPostInChecklist(this.mapPost);
}

class GetPostsFromChecklist extends MapEvent {}
