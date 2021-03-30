import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:socialpixel/data/models/profile.dart';
import 'package:socialpixel/data/repos/profile_repository.dart';

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
        final profile = await profileRepository.fetchProfile(event.username);
        print("Going to be yeeted");
        yield ProfileLoaded(profile);
      }
      if (event is GetCurrentProfile) {
        final profile = await profileRepository.fetchCurrentProfile();
        yield ProfileLoaded(profile);
      }
    } catch (e) {
      yield ProfileError("The profile does not exist");
    }
    try {
      if (event is GetProfileList) {
        final profiles = await profileRepository.fetchProfile(event.name);
        yield ProfileListLoaded([profiles]);
      }
    } catch (e) {
      print(e);
      yield ProfileError("No users found");
    }
    if (event is StartProfileInitial) {
      yield ProfileInitial();
    }
    // TODO: implement mapEventToState
  }
}
