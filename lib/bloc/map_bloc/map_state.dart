part of 'map_bloc.dart';

@immutable
abstract class MapState {}

class MapInitial extends MapState {}

class MapPostLoading extends MapState {}

class MapPostLoaded extends MapState {
  final List<MapPost> mapPosts;

  MapPostLoaded(this.mapPosts);
}

class MapPostInChecklistLoaded extends MapState {
  final List<MapPost> mapPosts;

  MapPostInChecklistLoaded(this.mapPosts);
}

class MapPostInChecklist extends MapState {
  final bool hasPost;

  MapPostInChecklist(this.hasPost);
}

class SubscribedGamesLoaded extends MapState {
  final List<Game> games;

  SubscribedGamesLoaded(this.games);
}

class MapPostAddedForValidation extends MapState {}

class MapPostError extends MapState {}

class PostValidated extends MapState {}

class PostValidateLoaded extends MapState {
  final Post originalPost;
  final Post comparedPost;

  PostValidateLoaded(this.originalPost, this.comparedPost);
}
