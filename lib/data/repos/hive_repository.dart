import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:socialpixel/data/models/comment.dart';
import 'package:socialpixel/data/models/location.dart';
import 'package:socialpixel/data/models/post.dart';
import 'package:socialpixel/data/models/profile.dart';
import 'package:image/image.dart' as imageLib;

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

  void addPosts(List<Post> posts) async {
    final box = await Hive.openBox('posts');
    // for (int i = 0; i > posts.length; i++) {
    //   // posts[i].userAvatarLink =
    // }
    box.addAll(posts);
  }

  void dispose() async {
    await Hive.close();
  }
}
