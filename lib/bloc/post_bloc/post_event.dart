part of 'post_bloc.dart';

@immutable
abstract class PostEvent {}

// This event is called when the app is started
class FetchPosts extends PostEvent {
  final int channelId;
  final bool includeComments;

  FetchPosts({this.includeComments = false, this.channelId = -1});
}

class FetchSearchedPost extends PostEvent {
  final List<String> hashtags;

  FetchSearchedPost({this.hashtags});
}

class UpvotePost extends PostEvent {
  final int postId;
  final bool upvote;

  UpvotePost({this.upvote, this.postId});
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
  final imageLib.Image image;
  final Location location;
  final DateTime photoDate;
  final String caption;

  SendPost({
    this.image,
    this.location,
    this.photoDate,
    this.caption,
  });
}
