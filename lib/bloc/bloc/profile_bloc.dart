import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:socialpixel/data/models/profile.dart';
import 'package:socialpixel/data/profile_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final profileRepository = ProfileRepository();
  ProfileBloc() : super(ProfileInitial());

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    yield ProfileLoading();
    try {
      if (event is GetProfile) {
        final profile = await profileRepository.fetchProfile(event.userId);
        yield ProfileLoaded(profile);
      }
    } catch (e) {
      yield ProfileError("The profile does not exist");
    }
    // TODO: implement mapEventToState
  }
}
