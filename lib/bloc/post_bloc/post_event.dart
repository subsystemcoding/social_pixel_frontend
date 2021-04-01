part of 'post_bloc.dart';

@immutable
abstract class PostEvent {}

// This event is called when the app is started
class StartPostInitial extends PostEvent {}

class FetchPosts extends PostEvent {
  final int channelId;
  final bool includeComments;

  FetchPosts({this.includeComments = false, this.channelId = -1});
}

class FetchPost extends PostEvent {
  final int postId;

  FetchPost(this.postId);
}

class FetchSearchedPost extends PostEvent {
  final String hashtags;

  FetchSearchedPost({this.hashtags});
}

class UpvotePost extends PostEvent {
  final Post post;
  final bool upvote;

  UpvotePost({this.upvote, this.post});
}

class CommentPost extends PostEvent {
  final int postId;
  final String text;

  CommentPost({this.text, this.postId});
}

class ReplyComment extends PostEvent {
  final int postId;
  final int commentId;
  final String text;

  ReplyComment(this.postId, this.commentId, this.text);
}

class FetchComments extends PostEvent {
  final Post post;

  FetchComments(this.post);
}

// Fetch posts in profile
class SendPost extends PostEvent {
  final Post post;
  final String imageLink;

  SendPost(this.post, this.imageLink);
}
