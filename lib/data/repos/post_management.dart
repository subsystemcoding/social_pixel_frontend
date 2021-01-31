import 'dart:convert';
import 'dart:math';

import 'package:socialpixel/data/models/post.dart';
import 'package:socialpixel/data/models/game.dart';
import 'package:socialpixel/data/test_data/test_data.dart';

enum PostSending {
  Successful,
  Unsuccessful,
  NoInternet,
}

class PostManagement {
  Random random;
  PostManagement() {
    random = Random();
  }

  Future<PostSending> sendPost(Post post, PostSending value) {
    return Future.delayed(Duration(milliseconds: 500), () {
      return value;
    });
  }

  Future<List<Game>> fetchGamePosts() {
    return Future.delayed(Duration(seconds: 1), () {
      return [
        Game(
            name: "First Game",
            description: "This the channel's first game",
            image:
                "https://data4.origin.com/asset/content/dam/originx/web/app/programs/About/aboutorigin_3840x2160_battlefield1.jpg/27051ac9-d3c0-49e3-9979-3dc1058a69f5/original.jpg"),
        Game(
            name: "Second Game",
            description:
                "This the channel's second game which is amazing and beyond explosion, muhahaha",
            image:
                "https://i.guim.co.uk/img/media/c6f7b43fa821d06fe1ab4311e558686529931492/168_84_1060_636/master/1060.jpg?width=1200&height=900&quality=85&auto=format&fit=crop&s=fd98bc73a66809dbb678b1a88aa6f96c")
      ];
    });
  }

  Future<List<Post>> fetchPosts() {
    return Future.delayed(
      Duration(seconds: 1),
      () {
        String jsonData = TestData.postData();
        List<dynamic> list = json.decode(jsonData);

        print(list[0]['postId']);

        List<Post> posts = list.map((obj) {
          print(obj.toString());
          print(obj.runtimeType.toString());
          return Post.fromMap(obj);
        }).toList();

        return posts;
      },
    );
  }
}
