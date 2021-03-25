import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:socialpixel/data/models/comment.dart';
import 'package:socialpixel/data/models/post.dart';
import 'package:socialpixel/data/models/profile.dart';

/*  notif string
time of notif
type of notif (int)
userAvatarLink  */

class Notif {
  final String notif;
  final String time;
  final int type;
  final String userAvatarLink;
  Notif({
    this.notif,
    this.time,
    this.type,
    this.userAvatarLink,
  });

  Notif copyWith({
    String notif,
    String time,
    int type,
    String userAvatarLink,
  }) {
    return Notif(
      notif: notif ?? this.notif,
      time: time ?? this.time,
      type: type ?? this.type,
      userAvatarLink: userAvatarLink ?? this.userAvatarLink,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'notif': notif,
      'time': time,
      'type': type,
      'userAvatarLink': userAvatarLink,
    };
  }

  factory Notif.fromMap(Map<String, dynamic> map) {
    return Notif(
      notif: map['notif'],
      time: map['time'],
      type: map['type'],
      userAvatarLink: map['userAvatarLink'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Notif.fromJson(String source) => Notif.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Notif(notif: $notif, time: $time, type: $type, userAvatarLink: $userAvatarLink)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Notif &&
        other.notif == notif &&
        other.time == time &&
        other.type == type &&
        other.userAvatarLink == userAvatarLink;
  }

  @override
  int get hashCode {
    return notif.hashCode ^
        time.hashCode ^
        type.hashCode ^
        userAvatarLink.hashCode;
  }
}
