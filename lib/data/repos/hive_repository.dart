import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:socialpixel/data/models/auth_object.dart';
import 'package:socialpixel/data/models/channel.dart';
import 'package:socialpixel/data/models/chatroom.dart';
import 'package:socialpixel/data/models/comment.dart';
import 'package:socialpixel/data/models/game.dart';
import 'package:socialpixel/data/models/location.dart';
import 'package:socialpixel/data/models/mapPost.dart';
import 'package:socialpixel/data/models/message.dart';
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
    Hive.registerAdapter(MapPostAdapter());
    Hive.registerAdapter(AuthObjectAdapter());
    Hive.registerAdapter(ChannelAdapter());
    Hive.registerAdapter(ChatroomAdapter());
    Hive.registerAdapter(GameAdapter());
    Hive.registerAdapter(MessageAdapter());
  }

  void dispose() async {
    await Hive.close();
  }
}
