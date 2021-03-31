part of 'profile_bloc.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final Profile profile;

  ProfileLoaded(this.profile);
}

class ProfileListLoaded extends ProfileState {
  final List<Profile> profiles;

  ProfileListLoaded(this.profiles);
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}

class UserFollowed extends ProfileState {}

class UserFollowedError extends ProfileState {}

class MessageUserSuccess extends ProfileState {
  final int chatroomId;

  MessageUserSuccess(this.chatroomId);
}

class MessageUserError extends ProfileState {}
