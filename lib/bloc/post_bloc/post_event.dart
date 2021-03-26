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
