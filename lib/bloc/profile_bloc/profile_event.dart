part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent {}

class GetProfile extends ProfileEvent {
  final String username;

  GetProfile(this.username);
}

class GetCurrentProfile extends ProfileEvent {}

class GetProfileList extends ProfileEvent {}
