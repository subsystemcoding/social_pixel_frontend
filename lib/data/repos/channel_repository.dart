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
      games: jsonResponse['gameSet'].map((item) {
        return Game(
            gameId: item['id'],
            name: item['name'],
            description: item['description'],
            image: item['image']);
      }),
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
