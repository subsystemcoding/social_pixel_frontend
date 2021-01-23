part of 'post_bloc.dart';

@immutable
abstract class PostEvent {}

class GetPost extends PostEvent {}

class GetPostAndGame extends PostEvent {}

class GetGame extends PostEvent {}

class SendPost extends PostEvent {
  final File imageFile;
  final String caption;
  final bool addLocation;

  SendPost({
    this.imageFile,
    this.addLocation,
    this.caption,
  });
}
