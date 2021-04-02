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
    if (event is GetProfile) {
      try {
        final profile = await profileRepository.fetchProfile(event.username);
        print("Going to be yeeted");
        yield ProfileLoaded(profile);
      } catch (e) {
        print("Error from GetProfile");
        print(e.toString());
        yield ProfileError("The profile does not exist");
      }
    } else if (event is GetCurrentProfile) {
      try {
        final profile = await profileRepository.fetchCurrentProfile();
        print("Going to be yeeted");
        yield ProfileLoaded(profile);
      } catch (e) {
        print("Error from GetProfile");
        print(e.toString());
        yield ProfileError("The profile does not exist");
      }
    } else if (event is GetProfileList) {
      try {
        final profiles = await profileRepository.fetchProfile(event.name);
        yield ProfileListLoaded([profiles]);
      } catch (e) {
        print(e);
        yield ProfileError("No users found");
      }
    } else if (event is StartProfileInitial) {
      yield ProfileInitial();
    } else if (event is FollowUser) {
      try {
        await profileRepository.followUserProfile(event.profile);
        yield UserFollowed();
      } catch (e) {
        print("UserFolowedError");
        print(e);
        yield UserFollowedError();
      }
    } else if (event is MessageUser) {
      try {
        int chatroomId = await profileRepository.createChatroom(event.profile);
        yield MessageUserSuccess(chatroomId);
      } catch (e) {
        print("MessageUserError");
        print(e);
        yield MessageUserError();
      }
    }
    // TODO: implement mapEventToState
  }
}
