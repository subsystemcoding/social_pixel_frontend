import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:hive_flutter/hive_flutter.dart';

class HiveRepository {
  static final HiveRepository _singleton = HiveRepository._internal();

  factory HiveRepository() {
    return _singleton;
  }

  HiveRepository._internal();

  void init() async {
    final dir = await path_provider.getApplicationDocumentsDirectory();
    final path = dir.path;
    await Hive.initFlutter(dir.path);
  }

  
}
