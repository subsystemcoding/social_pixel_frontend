part of 'post_bloc.dart';

@immutable
abstract class PostEvent {}

class GetPost extends PostEvent {}

class GetPostAndGame extends PostEvent {}

class GetGame extends PostEvent {}

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
