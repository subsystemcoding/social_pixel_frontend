import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:socialpixel/data/graphql_client.dart';
import 'package:socialpixel/data/models/channel.dart';
import 'package:socialpixel/data/models/game.dart';
import 'package:socialpixel/data/models/post.dart';
import 'package:socialpixel/data/models/profile.dart';
import 'package:socialpixel/data/repos/auth_repository.dart';
import 'package:socialpixel/data/test_data/test_data.dart';

class ProfileRepository {
  static final ProfileRepository _singleton = ProfileRepository._internal();
  GraphqlClient _client = GraphqlClient();
  final hiveBox = "profile";
  final userProfileHive = "userProfile";
  final randUserProfileHive = "randUserProfile";

  factory ProfileRepository() {
    return _singleton;
  }

  ProfileRepository._internal();

  Profile currentProfile;

  /*Need the following
    followers
    points
    coverImage
  */

  Future<Profile> fetchCurrentProfile() async {
    String username = await AuthRepository().getUsername();
    var response = await _client.query(''' 
    query {
      userprofile(username: "$username"){
        success,
        errors,
        user{
          username
          email
          dateJoined
        }
        bio
        visibility
        image
        postedBy {
          postId
          image150x150
        }
        upvotedBy{
          postId
        }
        memberIn{
          id
          name 
        }
        
      }
    }
    ''');
    var jsonResponse = jsonDecode(response)['data']['userprofile'];
    bool success = jsonResponse['success'];
    if (success) {
      Profile profile = Profile(
        username: jsonResponse['user']['username'],
        email: jsonResponse['user']['email'],
        createDate: jsonResponse['user']['dateJoined'],
        description: jsonResponse['bio'],
        userAvatarImage: jsonResponse['image'],
        postsMade: jsonResponse['postedBy'].map(
          (item) {
            return Post(
              postId: item['postId'],
              postImageLink: item['image150x150'],
            );
          },
        ),
        upvotedPosts: jsonResponse['upvotedBy'].map(
          (item) => Post(postId: item['postId']),
        ),
        subscribedChannels: jsonResponse['memberIn'].map(
          (item) => Channel(
            id: item['id'],
            name: item['name'],
          ),
        ),
      );
      await _saveCurrentProfileToCache(profile);
      return profile;
    }

    return null;
  }

  Future<Profile> fetchProfile(String username, {bool isUser = false}) async {
    var response = await _client.query(''' 
    query {
      userprofile(username: "$username"){
        success,
        errors,
        user{
          username
          email
          dateJoined
        }
        bio
        visibility
        image
        postedBy {
          postId
          image150x150
        }
        memberIn{
          id
          name 
        }
        
      }
    }
    ''');
    var jsonResponse = jsonDecode(response)['data']['userprofile'];
    bool success = jsonResponse['success'];
    if (success) {
      Profile profile = Profile(
        username: jsonResponse['user']['username'],
        email: jsonResponse['user']['email'],
        createDate: jsonResponse['user']['dateJoined'],
        description: jsonResponse['bio'],
        userAvatarImage: jsonResponse['image'],
        postsMade: jsonResponse['postedBy'].map(
          (item) {
            return Post(
              postId: item['postId'],
              postImageLink: item['image150x150'],
            );
          },
        ),
        upvotedPosts: jsonResponse['upvotedBy'].map(
          (item) => Post(postId: item['postId']),
        ),
        subscribedChannels: jsonResponse['memberIn'].map(
          (item) => Channel(
            id: item['id'],
            name: item['name'],
          ),
        ),
      );

      await _saveRandUserProfileToCache(profile);
      return profile;
    }

    return null;
  }

  Future<List<Game>> updateSubscribedGames() {
    return Future.delayed(
      Duration(milliseconds: 100),
      () {
        String jsonData = TestData.getSubscribedGamesForMap();
        Profile profile = Profile.fromJson(jsonData);

        return profile.subscribedGames;
      },
    );
  }

  // needs implementation of searching
  Future<List<Profile>> fetchProfileList() {
    return Future.delayed(
      Duration(milliseconds: 100),
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

  Future<void> _saveCurrentProfileToCache(Profile profile) async {
    final box = await Hive.openBox(hiveBox);
    box.put(userProfileHive, profile);
  }

  Future<void> _saveRandUserProfileToCache(Profile profile) async {
    final box = await Hive.openBox(hiveBox);
    box.put(randUserProfileHive, profile);
  }
}
