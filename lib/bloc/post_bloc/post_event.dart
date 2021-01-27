part of 'post_bloc.dart';

@immutable
abstract class PostEvent {}

class GetPost extends PostEvent {}

class GetPostAndGame extends PostEvent {}

class GetGame extends PostEvent {}

class SendPost extends PostEvent {
  final String imagePath;
  final String caption;
  final String location;

  SendPost({
    this.imagePath,
    this.location,
    this.caption,
  });
}
