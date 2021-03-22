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

class MapPostError extends MapState {}
