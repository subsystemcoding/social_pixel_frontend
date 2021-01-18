part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent {}

class GetProfile extends ProfileEvent {
  final int userId;

  GetProfile(this.userId);
}
