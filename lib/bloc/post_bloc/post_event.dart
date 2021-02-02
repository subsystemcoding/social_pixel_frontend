part of 'post_bloc.dart';

@immutable
abstract class PostEvent {}

// This event is called when the app is started
class FetchInitialPost extends PostEvent {
  final int channelId;

  FetchInitialPost({this.channelId = 0});
}

// This event is called when scrolling for more posts
class FetchMorePost extends PostEvent {
  final int channelId;

  FetchMorePost({this.channelId = 0});
}

// This event is called when refreshing to get new posts
class FetchNewPost extends PostEvent {
  final int channelId;

  FetchNewPost({this.channelId = 0});
}

class FetchSearchedPost extends PostEvent {
  final List<String> hashtags;

  FetchSearchedPost({this.hashtags});
}

// Fetch posts in profile
class FetchProfilePost extends PostEvent {
  final int userId;

  FetchProfilePost(this.userId);
}

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
