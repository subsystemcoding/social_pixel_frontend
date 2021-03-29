import 'dart:convert';

import 'package:socialpixel/data/graphql_client.dart';
import 'package:socialpixel/data/models/channel.dart';
import 'package:socialpixel/data/models/game.dart';
import 'package:socialpixel/data/test_data/test_data.dart';

class ChannelRepository {
  Future<Channel> fetchChannel(int channelId) async {
    var response = await GraphqlClient().query('''
      query {
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
            name
            id
            description
            image
          }
        }
      }
      ''');

    var jsonResponse = jsonDecode(response)['data']['channel'];
    int subscribers = jsonResponse['subscribers'].length;
    return Channel(
      id: channelId,
      name: jsonResponse['name'],
      description: jsonResponse['description'],
      subscribers: subscribers,
      coverImageLink: jsonResponse['coverImage'],
      avatarImageLink: jsonResponse['avatarImage'],
      games: jsonResponse['gameSet'].isNotEmpty
          ? List<Game>.from(jsonResponse['gameSet'].map((item) {
              return Game(
                  gameId: int.parse(item['id']),
                  name: item['name'],
                  description: item['description'],
                  image: item['image']);
            }))
          : null,
    );
  }

  Future<bool> subscribeToChannel(String channelName, String modifier) async {
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

  Future<bool> createChannel(
    String channelName,
    String avatarImagePath,
    String coverImagePath,
    String description,
  ) async {
    var response = await GraphqlClient().query('''
      mutation{
        createChannel(name: "$channelName", avatarImage: "$avatarImagePath" ,coverImage: "$coverImagePath", description: "$description"){
          success
        }
      }
      ''');
    return jsonDecode(response)['data']['success'];
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
