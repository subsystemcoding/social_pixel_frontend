import 'dart:convert';

import 'package:socialpixel/data/graphql_client.dart';
import 'package:socialpixel/data/models/auth_object.dart';
import 'package:socialpixel/data/models/channel.dart';
import 'package:socialpixel/data/models/chatroom.dart';
import 'package:socialpixel/data/models/game.dart';
import 'package:socialpixel/data/models/location.dart';
import 'package:socialpixel/data/models/post.dart';
import 'package:socialpixel/data/repos/auth_repository.dart';
import 'package:socialpixel/data/test_data/test_data.dart';

class ChannelRepository {
  static final ChannelRepository _singleton = ChannelRepository._internal();

  factory ChannelRepository() {
    return _singleton;
  }

  ChannelRepository._internal();

  Future<Channel> fetchChannel(int channelId) async {
    var authObject = await AuthRepository().getAuth();
    var username = authObject.username;
    var response = await GraphqlClient().query('''
      query{
        channel(id: $channelId){
          name
          description
          subscribers{
            user{
              username
            }
          }
          coverImage
          avatar
          gameSet{
            id
            name
            description
            image
            leaderboard{
              id
            }
          }
          postSet{
            postId 
            author{
              user{
                username
              }
              image
            }
            dateCreated
            caption
            gpsLongitude
            gpsLatitude
            upvotes{
              user{
                username
              }
            }
            comments {
              commentId
            }
            image
          }
        }
      }
      ''');

    var jsonResponse = jsonDecode(response)['data']['channel'];
    int subscribers = jsonResponse['subscribers'].length;
    List<String> _listsubscribers = List<String>.from(
            jsonResponse['subscribers']
                ?.map((subscriber) => subscriber['user']["username"])) ??
        [];

    return Channel(
      id: channelId,
      name: jsonResponse['name'],
      description: jsonResponse['description'],
      subscribers: subscribers,
      isSubscribed:
          _listsubscribers.contains(authObject.username) ? true : false,
      coverImageLink: jsonResponse['coverImage'],
      avatarImageLink: jsonResponse['avatar'],
      games: jsonResponse['gameSet'].isNotEmpty
          ? List<Game>.from(
              jsonResponse['gameSet'].map(
                (item) {
                  return Game(
                    gameId: int.parse(item['id']),
                    name: item['name'],
                    description: item['description'],
                    image: item['image'],
                    leaderboardId: int.parse(
                      item['leaderboard']['id'],
                    ),
                  );
                },
              ),
            )
          : [],
      posts: jsonResponse['postSet'].isEmpty
          ? []
          : List<Post>.from(
              jsonResponse['postSet'].map(
                (item) {
                  Post post = Post(
                    upvotes: item['upvotes'].length,
                    postId: int.parse(item['postId']),
                    userName: item['author']['user']['username'],
                    userAvatarLink: item['author']['image'],
                    postImageLink: item['image'],
                    caption: item['caption'],
                    datePosted: item['dateCreated'],
                    location: Location(
                      latitude: item['gpsLatitude'] != null
                          ? double.parse(item['gpsLatitude'])
                          : null,
                      longitude: item['gpsLongitude'] != null
                          ? double.parse(item['gpsLongitude'])
                          : null,
                    ),
                  );
                  post.isUpvoted = false;
                  for (var upvote in item['upvotes']) {
                    if (upvote['user']['username'] == username) {
                      post.isUpvoted = true;
                      break;
                    }
                  }
                  post.commentCount =
                      item['comments'] == null ? 0 : item['comments'].length;
                  return post;
                },
              ),
            ),
    );
  }

  Future<bool> subscribeToChannel(String channelName, bool isSub) async {
    var modifier = isSub ? "REMOVE" : "ADD";
    var response = await GraphqlClient().query('''
      mutation{
        channelSubscription(name: "$channelName",modifier: $modifier){
          success
        }
      }
      ''');

    return jsonDecode(response)['data']['success'];
  }

  Future<bool> changeChannelDescription(
      String channelName, String description) async {
    var response = await GraphqlClient().query('''
      mutation{
        channelChangeDescription(description: "$description", name: "$channelName"){
          success
        }
      }
      ''');
    return jsonDecode(response)['data']['success'];
  }

  Future<bool> changeCoverImage(String channelName, String imagePath) async {
    var response = await GraphqlClient().query('''
      mutation{
        channelChangeCoverImage(description: "$imagePath", name: "$channelName"){
          success
        }
      }
      ''');
    return jsonDecode(response)['data']['success'];
  }

  Future<bool> changeAvatarImage(String channelName, String imagePath) async {
    var response = await GraphqlClient().query('''
      mutation{
        channelChangeAvatarImage(description: "$imagePath", name: "$channelName"){
          success
        }
      }
      ''');
    return jsonDecode(response)['data']['success'];
  }

  Future<String> createChannel({Channel channel}) async {
    var response = await GraphqlClient().muiltiPartRequest(fields: {
      'query': '''
      mutation{
        createChannel(name: "${channel.name}", avatarImage: "avatarImagePath" ,coverImage: "coverImagePath", description: "${channel.description}"){
           channel{
              id
            }
        }
      }
      '''
    }, files: {
      "avatarImagePath": channel.avatarImageLink,
      "coverImagePath": channel.coverImageLink,
    });

    return jsonDecode(response)['data']['createChannel']['channel']['id'];
  }

  Future<bool> deleteChannel(
    String channelName,
    String avatarImagePath,
    String coverImagePath,
    String description,
  ) async {
    var response = await GraphqlClient().query('''
      mutation{
        deleteChannel(name: "$channelName"){
          success
        }
      }
      ''');
    return jsonDecode(response)['data']['success'];
  }

  Future<int> createChatroom(Channel channel, String roomName) async {
    var chatroomId;
    var response = await GraphqlClient().query('''
    mutation{
      createChatroom(name: "channel${channel.name}$roomName"){
      	chatroom{
          id
        }
      }
    }
    ''');
    chatroomId =
        jsonDecode(response)['data']['createChatroom']['chatroom']['id'];

    return chatroomId;
  }

  Future<Channel> fetchChannelsByName(String name) async {
    var response = await GraphqlClient().query(''' 
      query{
        channelname(name:"$name"){
          id
          subscribers{
            user{
              username
            }
          }
          avatar
          name
        }
      }
    ''');

    var jsonResponse = jsonDecode(response)['data']['channelname'];
    var subscribers = List.from(jsonResponse['subscribers']).length;
    return Channel(
      id: int.parse(jsonResponse['id']),
      subscribers: subscribers,
      avatarImageLink: jsonResponse['avatar'],
      name: jsonResponse['name'],
    );
  }

  Future<List<Channel>> fetchChannelList() {
    return Future.delayed(
      Duration(milliseconds: 100),
      () {
        String jsonData = TestData.channelListData();
        List<dynamic> list = json.decode(jsonData);

        List<Channel> profiles = list.map((obj) {
          return Channel.fromMap(obj);
        }).toList();

        return profiles;
      },
    );
  }
}
