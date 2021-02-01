import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:socialpixel/data/models/comment.dart';
import 'package:socialpixel/data/models/location.dart';
import 'package:socialpixel/data/models/post.dart';
import 'package:socialpixel/data/models/profile.dart';
import 'package:image/image.dart' as imageLib;
import 'package:socialpixel/data/repos/connectivity.dart';

class HiveRepository {
  static final HiveRepository _singleton = HiveRepository._internal();

  factory HiveRepository() {
    return _singleton;
  }

  HiveRepository._internal();

  Future<void> init() async {
    final dir = await path_provider.getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    Hive.registerAdapter(PostAdapter());
    Hive.registerAdapter(ProfileAdapter());
    Hive.registerAdapter(CommentAdapter());
    Hive.registerAdapter(LocationAdapter());
  }

  Future<List<Post>> getPosts() async {
    final box = await Hive.openBox('posts');
    List<Post> posts = [];
    for (int i = 0; i < box.length; i++) {
      posts.add(box.getAt(i));
    }
    return posts;
  }

  Future<void> addPosts(List<Post> posts) async {
    final box = await Hive.openBox('posts');

    List<Post> newList = [];
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

      final newPost = post.copyWith(
        userImageBytes: userAvatar,
        postImageBytes: postImage,
        otherUsers: otherUsers,
      );

      print("otheruser");
      print(newPost.otherUsers[0].userImageBytes.toString());
      //Add to box
      box.put(newPost.postId, newPost);
      //create a new list with the base 64 images
      // newList.add(
      //   posts[i].copyWith(
      //     userImageBytes: userAvatar,
      //     postImageBytes: postImage,
      //     otherUsers: otherUsers,
      //   ),
      // );
    }
    //add the new posts to images
    // box.addAll(newList);
  }

  Future<void> deleteAllPost() async {
    final box = await Hive.openBox('posts');
    await box.clear();
    print('deleted');
  }

  void showEntries() async {
    final box = await Hive.openBox('posts');
    print(box.values.toString());
  }

  void dispose() async {
    await Hive.close();
  }
}
