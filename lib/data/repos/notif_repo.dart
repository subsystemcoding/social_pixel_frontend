import 'dart:convert';
import 'dart:math';

import 'package:socialpixel/data/models/notif.dart';
import 'package:socialpixel/data/test_data/test_data.dart';

enum NotifGet {
  Successful,
  NoInternet,
}

class NotifManagement {
/*  Random random;
  NotifManagement() {
    random = Random();
  } */

  Future<List<Notif>> fetchNotifs() {
    return Future.delayed(
      Duration(seconds: 1),
      () {
        String jsonData = TestData.postData();
        List<dynamic> list = json.decode(jsonData);

        List<Notif> notifsList = list.map((obj) {
          return Notif.fromMap(obj);
        }).toList();

        return notifsList;
      },
    );
  }
}
