import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:hive/hive.dart';
import 'package:image/image.dart' as imageLib;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:socialpixel/data/graphql_client.dart';
import 'package:socialpixel/data/models/location.dart';
import 'package:socialpixel/data/models/mapPost.dart';
import 'package:socialpixel/data/models/game.dart';
import 'package:socialpixel/data/models/post.dart';
import 'package:socialpixel/data/models/profile.dart';
import 'package:socialpixel/data/repos/connectivity.dart';
import 'package:socialpixel/data/repos/hive_repository.dart';
import 'package:socialpixel/data/repos/profile_repository.dart';
import 'package:socialpixel/data/test_data/test_data.dart';

class MapRepository {
  Random random = Random();
  int currentPostId = 0;
  static final MapRepository _singleton = MapRepository._internal();

  factory MapRepository() {
    return _singleton;
  }

  MapRepository._internal();

  Future<List<MapPost>> fetchPostsByLocation(Location location) async {
    var response = await GraphqlClient().query('''
    query{
      postsByLocation(latitude: "${location.latitude}", longitude: "${location.longitude}", precision:ONEKILOMETER){
        postId
        author
        {
          user{
            username
          }
        }
        gpsLongitude
        gpsLatitude
        image 
        
      }
    }
    ''');

    var jsonResponse = jsonDecode(response)['data']['postsByLocation'];
    var mapPosts = List<MapPost>.from(jsonResponse.map((post) {
      return MapPost(
        post: Post(
          postId: int.parse(post['postId']),
          userName: post['author']['user']['username'],
          location: Location(
            latitude: double.parse(post['gpsLatitude']),
            longitude: double.parse(post['gpsLongitude']),
          ),
          userAvatarLink: post['author']['image'],
          postImageLink: post['image'],
        ),
      );
    }));

    //delete and add mapPosts in the background
    // _deleteAllPostInCache().then((_) async {
    //   await _addPostsToCache(mapPosts);
    // });
    await _deleteAllPostInCache();
    await _addPostsToCache(mapPosts);
    return mapPosts;
  }

  Future<List<MapPost>> _fetchPostsFromInternet() {
    return Future.delayed(
      Duration(milliseconds: 100),
      () async {
        String jsonData = TestData.postData();
        List<dynamic> list = json.decode(jsonData);

        List<Post> posts = list.map((post) {
          return Post.fromMap(post);
        }).toList();

        List<MapPost> mapPosts = posts.map((post) {
          return MapPost(
            post: post,
          );
        }).toList();

        return mapPosts.sublist(0, 5);
      },
    );
  }

  Future<bool> addPostForValidation(int originalPostId, int postId) async {
    var response = await GraphqlClient().query('''
    mutation{
      addPostForValidation(originalPostId: $originalPostId, postId: $postId,){
        success
      }
    }
    ''');
    return jsonDecode(response)['data']['addPostForValidation']['success'];
  }

  Future<bool> validatePost(int postId, bool accept) async {
    var modifier = accept ? "ACCEPT" : "REJECT";
    var response = await GraphqlClient().query(''' 
    mutation{
      validatePostWithoutGame(id: $postId, modifier: $modifier ){
        success
      }
    }
    ''');

    return jsonDecode(response)['data']['validatePostWithoutGame']['success'];
  }

  Future<List<Post>> getValidatePost() async {
    var response = await GraphqlClient().query('''
    query{
      validatePosts{
        id
        post{
          postId
          image
        }
        creatorPost{
          postId
          image
        }
      }
    }
    ''');

    var jsonResponse = jsonDecode(response)['data']['validatePosts'][0];
    return [
      Post(
        postId: int.parse(jsonResponse['creatorPost']['postId']),
        postImageLink: jsonResponse['creatorPost']['image'],
      ),
      Post(
        postId: int.parse(jsonResponse['post']['postId']),
        postImageLink: jsonResponse['post']['image'],
      ),
      Post(
        postId: int.parse(jsonResponse['id']),
      ),
    ];
  }

  Future<List<MapPost>> fetchCachedPosts() async {
    final box = await Hive.openBox('mapPosts');
    List<MapPost> mapPosts = [];
    for (int i = 0; i < box.length; i++) {
      mapPosts.add(box.getAt(i));
    }
    return mapPosts;
  }

  Future<List<Game>> fetchSubscribedGames() async {
    final games = await ProfileRepository().updateSubscribedGames();
    for (var game in games) {
      for (var mapPost in game.mapPosts) {
        Uint8List postImage =
            await Connectivity.networkImageToBytes(mapPost.post.postImageLink);
        mapPost.post.postImageBytes = postImage;
        Uint8List imagePin = await _imageToImagePin(
          postImage,
          color: Color(
            int.parse(game.pinColorHex, radix: 16),
          ),
        );
        mapPost.imagePin = imagePin;
      }
    }
    return games;
  }

  Future<bool> hasPostinChecklist(MapPost mapPost) async {
    final box = await Hive.openBox("PostChecklist");
    return box.keys.contains(mapPost.post.postId);
  }

  Future<MapPost> getPostInChecklist(int postId) async {
    final box = await Hive.openBox("PostChecklist");
    return await box.get(postId);
  }

  Future<void> addPostToChecklist(MapPost mapPost) async {
    final box = await Hive.openBox('PostChecklist');
    await box.put(mapPost.post.postId, mapPost);
  }

  Future<void> removePostFromChecklist(MapPost mapPost) async {
    final box = await Hive.openBox('PostChecklist');
    await box.delete(mapPost.post.postId);
  }

  Future<List<MapPost>> getAllPostInChecklist() async {
    final box = await Hive.openBox('PostChecklist');
    List<MapPost> mapPosts = [];
    for (int i = 0; i < box.length; i++) {
      mapPosts.add(box.getAt(i));
    }
    return mapPosts;
  }

  Future<void> _addPostsToCache(List<MapPost> mapPosts) async {
    final box = await Hive.openBox('mapPosts');

    for (int i = 0; i < mapPosts.length; i++) {
      //convert userAvatarLink to base64
      MapPost mapPost = mapPosts[i];
      final userAvatar = mapPost.post.userAvatarLink != null
          ? await Connectivity.networkImageToBytes(mapPost.post.userAvatarLink)
          : null;
      //convert postImageLink to base64
      final postImage = mapPost.post.postImageLink != null
          ? await Connectivity.networkImageToBytes(mapPost.post.postImageLink)
          : null;

      // add the new mapPost to the box
      final newPost = mapPost.post.copyWith(
        userImageBytes: userAvatar,
        postImageBytes: postImage,
      );

      //create the image pin
      final imagePin = await _imageToImagePin(postImage);
      //create the map post and assign it to the mapPost itself
      mapPost = mapPost.copyWith(
        post: newPost,
        imagePin: imagePin,
      );
      mapPosts[i] = mapPost;

      box.put(newPost.postId, mapPost);
    }
  }

  Future<void> _deleteAllPostInCache() async {
    final box = await Hive.openBox('mapPosts');
    await box.clear();
  }

  Future<Uint8List> _imageToImagePin(Uint8List image,
      {Color color = const Color(0xff7041ee)}) async {
    imageLib.Image image1 = imageLib.decodeImage(image);
    final image2Byte = await rootBundle.load('assets/images/pin.png');
    imageLib.Image image2 =
        imageLib.decodeImage(image2Byte.buffer.asUint8List());
    image2 = imageLib.colorOffset(
      image2,
      red: color.red,
      blue: color.blue,
      green: color.green,
    );
    imageLib.Image mergedImage = imageLib.Image(75, 75);
    mergedImage = imageLib.copyInto(mergedImage, image2);
    image1 = imageLib.copyResize(image1, width: 69, height: 47);
    mergedImage = imageLib.copyInto(mergedImage, image1, dstX: 3, dstY: 3);
    final mergedImageBytes = imageLib.encodePng(mergedImage) as Uint8List;

    return mergedImageBytes;
  }
}
