import 'dart:convert';
import 'dart:math';

import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:socialpixel/data/graphql_client.dart';
import 'package:socialpixel/data/models/location.dart';
import 'package:socialpixel/data/models/post.dart';
import 'package:socialpixel/data/models/game.dart';
import 'package:socialpixel/data/models/profile.dart';
import 'package:socialpixel/data/repos/connectivity.dart';
import 'package:socialpixel/data/repos/hive_repository.dart';
import 'package:socialpixel/data/test_data/test_data.dart';

enum PostSending {
  Successful,
  Unsuccessful,
  NoInternet,
}

class PostManagement {
  Random random = Random();
  int currentPostId = 0;
  static final PostManagement _singleton = PostManagement._internal();

  factory PostManagement() {
    return _singleton;
  }

  PostManagement._internal();

  Future<PostSending> sendPost(Post post, PostSending value) {
    return Future.delayed(Duration(milliseconds: 500), () {
      return value;
    });
  }

  Future<List<Game>> fetchGamePosts({int channelId}) {
    return Future.delayed(Duration(milliseconds: 100), () {
      String jsonData = TestData.gamePostData();
      List<dynamic> list = json.decode(jsonData);

      List<Game> games = list.map((obj) {
        return Game.fromMap(obj);
      }).toList();

      return games;
    });
  }

  Future<List<Post>> fetchSearchedPosts({List<String> hashtags}) async {
    List<Post> posts;

    //delete and add posts in the background
    _addPostsToCache(posts);
    return posts;
  }

  Future<List<Post>> fetchPosts({int channelId, bool includeComments}) async {
    //allow for comments
    String comments = includeComments
        ? '''
    comments{
      commentId
      author{
        user{
          username
        }
        image
      }
      commentContent
      dateCreated
      replies{
        commentId
        author{
          user{
            username
          }
          image
        }
        commentContent
        dateCreated
      }
      
    }
    '''
        : '';

    var response = await GraphqlClient().query(''' 
    query {
      feedPosts{
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
          user {
            username
          }
        }
        $comments
        image
      } 
    }
    ''');

    var jsonResponse = jsonDecode(response)['data']['feedPosts'];
    List<Post> posts = jsonResponse.map(
      (item) => Post(
        postId: item['postId'],
        userName: item['author']['user']['username'],
        userAvatarLink: item['author']['image'],
        postImageLink: item['image'],
        caption: item['caption'],
        datePosted: item['dateCreated'],
        comments: item['comments'],
        location: Location(
          latitude: item['gpsLatitude'],
          longitude: item['gpsLongitude'],
        ),
      ),
    );

    //delete and add posts in the background
    _deleteAllPostInCache().then((_) async {
      await _addPostsToCache(posts);
    });
    return posts;
  }

  Future<List<Post>> fetchCachedPosts() async {
    final box = await Hive.openBox('posts');
    List<Post> posts = [];
    for (int i = 0; i < box.length; i++) {
      posts.add(box.getAt(i));
    }
    return posts;
  }

  Future<void> _addPostsToCache(List<Post> posts) async {
    final box = await Hive.openBox('posts');

    for (int i = 0; i < posts.length; i++) {
      //convert userAvatarLink to base64
      final post = posts[i];
      final userAvatar =
          await Connectivity.networkImageToBytes(post.userAvatarLink);
      //convert postImageLink to base64
      final postImage =
          await Connectivity.networkImageToBytes(post.postImageLink);
      //convert otherUsers avatar to base64
      List<Profile> otherUsers = [];
      for (int j = 0; j < post.otherUsers.length; j++) {
        final user = post.otherUsers[j];
        final avatar =
            await Connectivity.networkImageToBytes(user.userAvatarImage);
        otherUsers.add(user.copyWith(userImageBytes: avatar));
      }

      // add the new post to the box
      final newPost = post.copyWith(
        userImageBytes: userAvatar,
        postImageBytes: postImage,
        otherUsers: otherUsers,
      );

      box.put(newPost.postId, newPost);
    }
  }

  Future<bool> upvotePost({int postId, String modifier = "ADD"}) async {
    var response = await GraphqlClient().query('''
      mutation {
        postUpvote(postId: $postId, modifier: $modifier){
          success
        }
      }
      ''');
    var jsonResponse = jsonDecode(response)['data']['postUpvote'];
    return jsonResponse['success'];
  }

  Future<bool> addComment({int postId, String text}) {
    var response = ''' 
    mutation {
      postComment(postId: $postId, text : "$text"){
        success
      }
    }
    ''';
    return jsonDecode(response)['data']['postComment']['success'];
  }

  Future<void> _deleteAllPostInCache() async {
    final box = await Hive.openBox('posts');
    await box.clear();
  }
}
