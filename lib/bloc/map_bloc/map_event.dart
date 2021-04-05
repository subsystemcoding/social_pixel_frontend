part of 'map_bloc.dart';

@immutable
abstract class MapEvent {}

class GetPosts extends MapEvent {
  final Location location;

  GetPosts(this.location);
}

class ValidatePost extends MapEvent {
  final int postId;
  final bool correct;

  ValidatePost(this.postId, this.correct);
}

class GetValidatePost extends MapEvent {}

class AddPostForValidation extends MapEvent {
  final int originalPostId;
  final Post post;

  AddPostForValidation(this.originalPostId, this.post);
}

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

class GetSubscribedGames extends MapEvent {}
