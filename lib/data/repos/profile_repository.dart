import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:socialpixel/data/debug_mode.dart';
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

  Future<Profile> fetchCurrentProfile() async {
    // if (DebugMode.debug) {
    //   return _fetchProfileDebug();
    // }
    final authObject = await AuthRepository().getAuth();
    String username = authObject.username;
    var response = await _client.query(''' 
    query {
      userprofile(username: "$username"){
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

    Profile profile = Profile(
      username: jsonResponse['user']['username'],
      email: jsonResponse['user']['email'],
      createDate: jsonResponse['user']['dateJoined'],
      description: jsonResponse['bio'],
      userAvatarImage: jsonResponse['image'],
      postsMade: List<Post>.from(
        jsonResponse['postedBy'].map(
          (item) {
            return Post(
              postId: int.parse(item['postId']),
              postImageLink: item['image150x150'],
            );
          },
        ),
      ),
      upvotedPosts: List<Post>.from(
        jsonResponse['upvotedBy']?.map(
          (item) => Post(postId: int.parse(item['postId'])),
        ),
      ),
      subscribedChannels: List<Channel>.from(
        jsonResponse['memberIn']?.map(
          (item) => Channel(
            id: int.parse(item['id']),
            name: item['name'],
          ),
        ),
      ),
    );
    return profile;
  }

  Future<Profile> fetchProfile(String username, {bool isUser = false}) async {
    if (DebugMode.debug) {
      return _fetchProfileDebug();
    }

    final authObject = await AuthRepository().getAuth();
    if (username == authObject.username) {
      return fetchCurrentProfile();
    }
    var response = await _client.query(''' 
    query {
      userprofile(username: "$username"){
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
    Profile profile = Profile(
      username: jsonResponse['user']['username'],
      email: jsonResponse['user']['email'],
      createDate: jsonResponse['user']['dateJoined'],
      description: jsonResponse['bio'],
      userAvatarImage: jsonResponse['image'],
      postsMade: List<Post>.from(
        jsonResponse['postedBy']?.map(
          (item) {
            return Post(
              postId: int.parse(item['postId']),
              postImageLink: item['image150x150'],
            );
          },
        ),
      ),
      upvotedPosts: List<Post>.from(
        jsonResponse['upvotedBy']?.map(
          (item) => Post(postId: int.parse(item['postId'])),
        ),
      ),
      subscribedChannels: List<Channel>.from(
        jsonResponse['memberIn']?.map(
          (item) => Channel(
            id: int.parse(item['id']),
            name: item['name'],
          ),
        ),
      ),
    );
    return profile;
  }

  Future<Profile> _fetchProfileDebug() {
    return Future.delayed(Duration(milliseconds: 50), () {
      var data = TestData.profileData();
      Profile profile = Profile.fromJson(data);

      return profile;
    });
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
}
