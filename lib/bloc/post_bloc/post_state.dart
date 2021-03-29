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

class PostUpvoted extends PostState {}

class PostUpvotedError extends PostState {}

class PostCommentsFetched extends PostState {
  final Post post;

  PostCommentsFetched(this.post);
}

class PostCommentsFetchedError extends PostState {}

class PostCommented extends PostState {
  final Comment comment;

  PostCommented(this.comment);
}

class PostCommentError extends PostState {}

class PostError extends PostState {
  final String message;
  PostError(this.message);
}

class PostSent extends PostState {
  final PostSending value;
  PostSent(this.value);
}
