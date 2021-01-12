part of 'post_bloc.dart';

@immutable
abstract class PostState {}

class PostInitial extends PostState {
  PostInitial();
}

class PostLoading extends PostState {
  PostLoading();
}

class PostLoaded extends PostState {
  final List<Post> posts;
  PostLoaded(this.posts);
}

class PostError extends PostState {
  final String message;
  PostError(this.message);
}

class GamePostLoaded extends PostState {
  final List<Game> games;
  GamePostLoaded(this.games);
}
