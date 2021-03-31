import 'dart:convert';
import 'dart:developer';

import 'package:geocoder/geocoder.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:socialpixel/data/debug_mode.dart';
import 'package:socialpixel/data/graphql_client.dart';
import 'package:socialpixel/data/models/comment.dart';
import 'package:socialpixel/data/models/location.dart';
import 'package:socialpixel/data/models/post.dart';
import 'package:socialpixel/data/models/game.dart';
import 'package:socialpixel/data/models/profile.dart';
import 'package:socialpixel/data/repos/auth_repository.dart';
import 'package:socialpixel/data/repos/connectivity.dart';
import 'package:socialpixel/data/repos/hive_repository.dart';
import 'package:socialpixel/data/test_data/test_data.dart';

enum PostSending {
  Successful,
  Unsuccessful,
  NoInternet,
}

class PostManagement {
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
    String tags = '[';
    for (int i = 0; i < hashtags.length; i++) {
      tags += '"${hashtags[i]}"';
      if (i != hashtags.length - 1) {
        tags += ',';
      }
    }
    tags += ']';
    log("Printing tagsss");
    log(tags);
    var response = await GraphqlClient().query('''
    query{
      postsByTag(tags: $tags)
      {
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
        comments {
          commentId
        }
        image
      }
    }
    ''');

    var jsonResponse = jsonDecode(response)['data']['postsByTag'];
    if (jsonResponse.isNotEmpty) {
      List<Post> posts = List<Post>.from(
        jsonResponse.map(
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
            post.commentCount =
                item['comments'] == null ? 0 : item['comments'].length;
            return post;
          },
        ),
      );
      return posts;
    }
    return [];
  }

  Future<List<Post>> fetchPosts({int channelId}) async {
    //allow for comments
    var auth = await AuthRepository().getAuth();
    var username = auth.username;

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
        comments {
          commentId
        }
        image
      } 
    }
    ''');

    var jsonResponse = jsonDecode(response)['data']['feedPosts'];
    if (jsonResponse.isNotEmpty) {
      List<Post> posts = List<Post>.from(
        jsonResponse.map(
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
      );
      print("//////////////////////Priniting posts////////////////////");
      print(posts);
      //delete and add posts in the background
      await _deleteAllPostInCache();
      await _addPostsToCache(posts);
      return posts;
    }
    return [];
  }

  Future<bool> postReplyToComment(
      {int postId, int commentId, String text}) async {
    var response = await GraphqlClient().query('''
    mutation{
      postCommentReply(postId: $postId, replyToId: $commentId, text: "$text"){
        success
      }
    }
    ''');

    return jsonDecode(response)['data']['postCommentReply']['success'];
  }

  Future<List<Post>> fetchCachedPosts() async {
    final box = await Hive.openBox('posts');
    List<Post> posts = [];
    for (int i = 0; i < box.length; i++) {
      posts.add(box.getAt(i));
    }
    return posts;
  }

  Future<Post> fetchPostComments(Post post) async {
    var response = await GraphqlClient().query(''' 
    query{
      post(id: ${post.postId}){
        comments{
          commentId
          commentContent
          author{
            user{
              username
            }
            image
          }
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
      }
    }
    ''');

    var jsonResponse = jsonDecode(response)['data']['post']['comments'];
    List<Comment> comments = List<Comment>.from(
      jsonResponse.map(
        (comment) {
          return Comment(
            commentId: int.parse(comment['commentId']),
            commentContent: comment['commentContent'],
            user: Profile(
                username: comment['author']['user']['username'],
                userAvatarImage: comment['author']['image']),
            dateCreated: comment['dateCreated'],
            replies: List<Comment>.from(
              comment['replies'].map(
                (reply) {
                  return Comment(
                    commentId: int.parse(reply['commentId']),
                    commentContent: reply['commentContent'],
                    user: Profile(
                        username: reply['author']['user']['username'],
                        userAvatarImage: reply['author']['image']),
                    dateCreated: reply['dateCreated'],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
    post.comments = comments;

    return post;
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
      final address = post.location.latitude != null
          ? await Geocoder.local.findAddressesFromCoordinates(
              Coordinates(
                post.location.latitude,
                post.location.longitude,
              ),
            )
          : null;
      final addressString = address != null
          ? '${address.first.adminArea}, ${address.first.countryName}'
          : '';
      post.location.address = addressString;

      // add the new post to the box
      final newPost = post.copyWith(
        userImageBytes: userAvatar,
        postImageBytes: postImage,
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

  Future<bool> addComment({int postId, String text}) async {
    var response = await GraphqlClient().query(''' 
    mutation {
      postComment(postId: $postId, text : "$text"){
        success
      }
    }
    ''');
    return jsonDecode(response)['data']['postComment']['success'];
  }

  Future<void> _deleteAllPostInCache() async {
    final box = await Hive.openBox('posts');
    await box.clear();
  }
}
