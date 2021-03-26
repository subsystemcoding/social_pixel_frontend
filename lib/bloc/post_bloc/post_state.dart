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

class PostUpvoted extends PostState {
  final bool success;

  PostUpvoted(this.success);
}

class PostCommented extends PostState {
  final bool success;

  PostCommented(this.success);
}

class PostError extends PostState {
  final String message;
  PostError(this.message);
}

class PostSent extends PostState {
  final PostSending value;
  PostSent(this.value);
}
