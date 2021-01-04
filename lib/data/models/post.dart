import 'dart:convert';

import 'package:flutter/foundation.dart';

class Post {
  final int postId;
  final String userName;
  final String userAvatarLink;
  final String datePosted;
  final String postImageLink;
  final String status;
  final String caption;
  final List<String> otherUsers;
  final String gpsTag;
  Post({
    this.postId,
    this.userName,
    this.userAvatarLink,
    this.datePosted,
    this.postImageLink,
    this.status,
    this.caption,
    this.otherUsers,
    this.gpsTag,
  });

  Post copyWith({
    int postId,
    String userName,
    String userAvatarLink,
    String datePosted,
    String postImageLink,
    String status,
    String caption,
    List<String> otherUsers,
    String gpsTag,
  }) {
    return Post(
      postId: postId ?? this.postId,
      userName: userName ?? this.userName,
      userAvatarLink: userAvatarLink ?? this.userAvatarLink,
      datePosted: datePosted ?? this.datePosted,
      postImageLink: postImageLink ?? this.postImageLink,
      status: status ?? this.status,
      caption: caption ?? this.caption,
      otherUsers: otherUsers ?? this.otherUsers,
      gpsTag: gpsTag ?? this.gpsTag,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'userName': userName,
      'userAvatarLink': userAvatarLink,
      'datePosted': datePosted,
      'postImageLink': postImageLink,
      'status': status,
      'caption': caption,
      'otherUsers': otherUsers,
      'gpsTag': gpsTag,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Post(
      postId: map['postId'],
      userName: map['userName'],
      userAvatarLink: map['userAvatarLink'],
      datePosted: map['datePosted'],
      postImageLink: map['postImageLink'],
      status: map['status'],
      caption: map['caption'],
      otherUsers: List<String>.from(map['otherUsers']),
      gpsTag: map['gpsTag'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Post.fromJson(String source) => Post.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Post(postId: $postId, userName: $userName, userAvatarLink: $userAvatarLink, datePosted: $datePosted, postImageLink: $postImageLink, status: $status, caption: $caption, otherUsers: $otherUsers, gpsTag: $gpsTag)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Post &&
        o.postId == postId &&
        o.userName == userName &&
        o.userAvatarLink == userAvatarLink &&
        o.datePosted == datePosted &&
        o.postImageLink == postImageLink &&
        o.status == status &&
        o.caption == caption &&
        listEquals(o.otherUsers, otherUsers) &&
        o.gpsTag == gpsTag;
  }

  @override
  int get hashCode {
    return postId.hashCode ^
        userName.hashCode ^
        userAvatarLink.hashCode ^
        datePosted.hashCode ^
        postImageLink.hashCode ^
        status.hashCode ^
        caption.hashCode ^
        otherUsers.hashCode ^
        gpsTag.hashCode;
  }
}
