part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent {}

class GetProfile extends ProfileEvent {
  final String username;

  GetProfile(this.username);
}

class GetCurrentProfile extends ProfileEvent {}

class StartProfileInitial extends ProfileEvent {}

class GetProfileList extends ProfileEvent {
  final String name;

  GetProfileList(this.name);
}

class FollowUser extends ProfileEvent {
  final Profile profile;

  FollowUser(this.profile);
}

class MessageUser extends ProfileEvent {
  final Profile profile;

  MessageUser(this.profile);
}
