import 'dart:convert';

import 'package:socialpixel/data/models/profile.dart';
import 'package:socialpixel/data/test_data/test_data.dart';

class ProfileRepository {
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
