import 'dart:convert';

import 'package:socialpixel/data/models/game.dart';
import 'package:socialpixel/data/models/profile.dart';
import 'package:socialpixel/data/test_data/test_data.dart';

class ProfileRepository {
  static final ProfileRepository _singleton = ProfileRepository._internal();

  factory ProfileRepository() {
    return _singleton;
  }

  ProfileRepository._internal();

  Profile currentProfile;

  Future<Profile> fetchProfile(int userId) {
    return Future.delayed(
      Duration(seconds: 1),
      () {
        String jsonData = TestData.profileData();

        Profile profile = Profile.fromJson(jsonData);

        return profile;
      },
    );
  }

  Future<List<Game>> updateSubscribedGames() {
    return Future.delayed(
      Duration(seconds: 1),
      () {
        String jsonData = TestData.getSubscribedGamesForMap();
        Profile profile = Profile.fromJson(jsonData);

        return profile.subscribedGames;
      },
    );
  }

  Future<List<Profile>> fetchProfileList() {
    return Future.delayed(
      Duration(seconds: 1),
      () {
        String jsonData = TestData.profileListData();
        List<dynamic> list = json.decode(jsonData);

        List<Profile> profiles = list.map((obj) {
          return Profile.fromMap(obj);
        }).toList();

        return profiles;
      },
    );
  }
}
