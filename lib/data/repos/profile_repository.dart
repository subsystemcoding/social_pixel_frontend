import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socialpixel/data/debug_mode.dart';
import 'package:socialpixel/data/graphql_client.dart';
import 'package:socialpixel/data/models/auth_object.dart';
import 'package:socialpixel/data/models/channel.dart';
import 'package:socialpixel/data/models/chatroom.dart';
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
        points
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
        subscribed{
          id
          name
          avatar
        }
        gameSet{
          id
          name
          leaderboard{
            id
          }
          channel{
            name
          }
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
      points: jsonResponse['points'],
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
      chatrooms: List<Chatroom>.from(
        jsonResponse['memberIn']?.map(
          (item) => Chatroom(
            id: int.parse(item['id']),
            name: item['name'],
          ),
        ),
      ),
      subscribedChannels: List<Channel>.from(
        jsonResponse['subscribed']?.map(
          (item) => Channel(
            id: int.parse(item['id']),
            name: item['name'],
            avatarImageLink: item['avatar'],
          ),
        ),
      ),
      subscribedGames: List<Game>.from(jsonResponse['gameSet']?.map(
        (item) => Game(
          gameId: int.parse(item['id']),
          channel: Channel(name: item['channel']['name']),
          name: item['name'],
          leaderboardId: int.parse(item['leaderboard']['id']),
        ),
      )),
      isUser: true,
      isVerified: false,
    );

    profile.followers = await _getNumOfFollowersOfUser(profile.username);
    return profile;
  }

  Future<Profile> fetchProfile(String username, {bool isUser = false}) async {
    final authObject = await AuthRepository().getAuth();
    if (username == authObject.username) {
      return fetchCurrentProfile();
    }

    var response = await _client.query(''' 
    query {
      userprofile(username: "$username"){
        user{
          username
          dateJoined
          email
        }
        bio
        image
        points
        coverImage 
        postedBy{
          postId
          image200x200
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
      points: jsonResponse['points'],
      followers: 0,
      userAvatarImage: jsonResponse['image'],
      userCoverImage: jsonResponse['coverImage'],
      postsMade: jsonResponse['postedBy'] != null
          ? List<Post>.from(
              jsonResponse['postedBy'].map(
                (item) {
                  return Post(
                    postId: int.parse(item['postId']),
                    postImageLink: item['image200x200'],
                  );
                },
              ),
            )
          : [],
      chatrooms: jsonResponse['memberIn'] != null
          ? List<Chatroom>.from(
              jsonResponse['memberIn'].map(
                (item) => Chatroom(
                  id: int.parse(item['id']),
                  name: item['name'],
                ),
              ),
            )
          : [],
      isUser: false,
      isVerified: false,
    );

    profile.isFollowing = await _isUserFollowing(profile.username);
    profile.followers = await _getNumOfFollowersOfUser(profile.username);
    return profile;
  }

  Future<Profile> _fetchProfileDebug() {
    return Future.delayed(Duration(milliseconds: 50), () {
      var data = TestData.profileData();
      Profile profile = Profile.fromJson(data);

      return profile;
    });
  }

  Future<int> _getNumOfFollowersOfUser(String username) async {
    var response = await GraphqlClient().query(''' 
    query{
      userprofilefollowersnumberbyusername(username: "$username")
    }
    ''');

    return jsonDecode(response)['data']['userprofilefollowersnumberbyusername'];
  }

  Future<bool> _isUserFollowing(String username) async {
    var response = await GraphqlClient().query(''' 
    query{
      userprofilefollowing{
        user{
          username
        }
      }
    }
    ''');

    var jsonResponse = jsonDecode(response)['data']['userprofilefollowing'];
    for (var user in jsonResponse) {
      if (user['user']['username'] == username) {
        return true;
      }
    }

    return false;
  }

  Future<List<Profile>> searchProfiles(String username) async {
    var response = await GraphqlClient().query('''
      query{
        userprofileSearch(query: "$username"){
          user{
            username
            dateJoined
            email
          }
          bio
          image
          points
          coverImage 
          postedBy{
            postId
            image200x200
          }
          memberIn{
            id
            name
          }
        }
      }
      ''');

    var jsonResponse = jsonDecode(response)['data']['userprofileSearch'];
    List<Profile> profiles = List<Profile>.from(
      jsonResponse.map(
        (profile) {
          return Profile(
            username: profile['user']['username'],
            email: profile['user']['email'],
            createDate: profile['user']['dateJoined'],
            description: profile['bio'],
            points: profile['points'],
            followers: 0,
            userAvatarImage: profile['image'],
            userCoverImage: profile['coverImage'],
            postsMade: profile['postedBy'] != null
                ? List<Post>.from(
                    profile['postedBy'].map(
                      (item) {
                        return Post(
                          postId: int.parse(item['postId']),
                          postImageLink: item['image200x200'],
                        );
                      },
                    ),
                  )
                : [],
            chatrooms: profile['memberIn'] != null
                ? List<Chatroom>.from(
                    profile['memberIn'].map(
                      (item) => Chatroom(
                        id: int.parse(item['id']),
                        name: item['name'],
                      ),
                    ),
                  )
                : [],
            isUser: false,
            isVerified: false,
          );
        },
      ),
    );

    for (Profile profile in profiles) {
      profile.isFollowing = await _isUserFollowing(profile.username);
      profile.followers = await _getNumOfFollowersOfUser(profile.username);
    }
    return profiles;
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

  Future<bool> followUserProfile(Profile profile) async {
    var modifier = !profile.isFollowing ? "ADD" : "REMOVE";
    var response = await GraphqlClient().query('''
    mutation{
      userRelationship(username: "${profile.username}", modifier: $modifier){
        success
      }
    }
    ''');

    var result = jsonDecode(response)['data']['userRelationship']['success'];

    if (profile.isFollowing) {
      profile.followers--;
    } else {
      profile.followers++;
    }
    profile.isFollowing = !profile.isFollowing;

    return result;
  }

  Future<int> _getChatroom(Profile profile) async {
    var authObject = await AuthRepository().getAuth();
    print("Printing usernames");
    print("${authObject.username}");
    print("${profile.username}");
    for (var chatroom in profile.chatrooms) {
      print("Printing chatroom");
      print(chatroom.name);
      if (chatroom.name == "${authObject.username}${profile.username}" ||
          chatroom.name == "${profile.username}${authObject.username}") {
        return chatroom.id;
      }
    }
    return null;
  }

  Future<int> createChatroom(Profile profile) async {
    var authObject = await AuthRepository().getAuth();
    var chatroomId = await _getChatroom(profile);
    if (chatroomId == null) {
      var response = await GraphqlClient().query('''
    mutation{
      createChatroom(name: "${authObject.username}${profile.username}", members:["${authObject.username}", "${profile.username}"]){
      	chatroom{
          id
        }
      }
    }
    ''');
      chatroomId = int.parse(
          jsonDecode(response)['data']['createChatroom']['chatroom']['id']);
    }
    return chatroomId;
  }
}
