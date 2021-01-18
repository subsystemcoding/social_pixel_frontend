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
