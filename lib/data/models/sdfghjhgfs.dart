import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:socialpixel/data/models/post.dart';
import 'package:socialpixel/data/models/profile.dart';

class Notif {
  final String mainUser;
  final String action;
  final List<Profile> otherUsers;
  final String notif;
  final String caption;
  final String time;
  final String userAvatarLink;
  final Post post;
  Notif({
    this.mainUser,
    this.action,
    this.otherUsers,
    this.notif,
    this.caption,
    this.time,
    this.userAvatarLink,
    this.post,
  });

  Notif copyWith({
    String mainUser,
    String action,
    List<Profile> otherUsers,
    String notif,
    String caption,
    String time,
    String userAvatarLink,
    Post post,
  }) {
    return Notif(
      mainUser: mainUser ?? this.mainUser,
      action: action ?? this.action,
      otherUsers: otherUsers ?? this.otherUsers,
      notif: notif ?? this.notif,
      caption: caption ?? this.caption,
      time: time ?? this.time,
      userAvatarLink: userAvatarLink ?? this.userAvatarLink,
      post: post ?? this.post,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mainUser': mainUser,
      'action': action,
      'otherUsers': otherUsers?.map((x) => x.toMap())?.toList(),
      'notif': notif,
      'caption': caption,
      'time': time,
      'userAvatarLink': userAvatarLink,
      'post': post.toMap(),
    };
  }

  factory Notif.fromMap(Map<String, dynamic> map) {
    return Notif(
      mainUser: map['mainUser'],
      action: map['action'],
      otherUsers:
          List<Profile>.from(map['otherUsers']?.map((x) => Profile.fromMap(x))),
      notif: map['notif'],
      caption: map['caption'],
      time: map['time'],
      userAvatarLink: map['userAvatarLink'],
      post: Post.fromMap(map['post']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Notif.fromJson(String source) => Notif.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Notif(mainUser: $mainUser, action: $action, otherUsers: $otherUsers, notif: $notif, caption: $caption, time: $time, userAvatarLink: $userAvatarLink, post: $post)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Notif &&
        other.mainUser == mainUser &&
        other.action == action &&
        listEquals(other.otherUsers, otherUsers) &&
        other.notif == notif &&
        other.caption == caption &&
        other.time == time &&
        other.userAvatarLink == userAvatarLink &&
        other.post == post;
  }

  @override
  int get hashCode {
    return mainUser.hashCode ^
        action.hashCode ^
        otherUsers.hashCode ^
        notif.hashCode ^
        caption.hashCode ^
        time.hashCode ^
        userAvatarLink.hashCode ^
        post.hashCode;
  }
}
