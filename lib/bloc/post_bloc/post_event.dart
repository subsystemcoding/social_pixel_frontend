part of 'post_bloc.dart';

@immutable
abstract class PostEvent {}

class GetPost extends PostEvent {}

class GetPostAndGame extends PostEvent {}

class GetGame extends PostEvent {}
