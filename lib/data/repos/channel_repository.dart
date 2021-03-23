import 'dart:convert';

import 'package:socialpixel/data/models/channel.dart';
import 'package:socialpixel/data/test_data/test_data.dart';

class ChannelRepository {
  Future<Channel> fetchChannel(int channelId) {
    return Future.delayed(
      Duration(milliseconds: 100),
      () {
        String jsonData = TestData.channelData();

        Channel channel = Channel.fromJson(jsonData);

        return channel;
      },
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
