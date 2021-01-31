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
      String jsonData = TestData.gamePostData();
      List<dynamic> list = json.decode(jsonData);

      List<Game> games = list.map((obj) {
        return Game.fromMap(obj);
      }).toList();

      //print(games);

      return games;
    });
  }

  Future<List<Post>> fetchPosts() {
    return Future.delayed(
      Duration(seconds: 1),
      () {
        String jsonData = TestData.postData();
        List<dynamic> list = json.decode(jsonData);

        List<Post> posts = list.map((obj) {
          return Post.fromMap(obj);
        }).toList();

        return posts;
      },
    );
  }
}
