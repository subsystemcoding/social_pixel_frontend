import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:socialpixel/data/models/comment.dart';

class Post {
  final int postId;
  final String userName;
  final String userAvatarLink;
  final String datePosted;
  final String postImageLink;
  final String caption;
  final List<String> otherUsers;
  final int upvotes;
  final List<Comment> commentCount;
  final List<Comment> comments;
  final String gpsTag;
  Post({
    this.postId,
    this.userName,
    this.userAvatarLink,
    this.datePosted,
    this.postImageLink,
    this.caption,
    this.otherUsers,
    this.upvotes,
    this.commentCount,
    this.comments,
    this.gpsTag,
  });

  Post copyWith({
    int postId,
    String userName,
    String userAvatarLink,
    String datePosted,
    String postImageLink,
    String caption,
    List<String> otherUsers,
    int upvotes,
    List<Comment> commentCount,
    List<Comment> comments,
    String gpsTag,
  }) {
    return Post(
      postId: postId ?? this.postId,
      userName: userName ?? this.userName,
      userAvatarLink: userAvatarLink ?? this.userAvatarLink,
      datePosted: datePosted ?? this.datePosted,
      postImageLink: postImageLink ?? this.postImageLink,
      caption: caption ?? this.caption,
      otherUsers: otherUsers ?? this.otherUsers,
      upvotes: upvotes ?? this.upvotes,
      commentCount: commentCount ?? this.commentCount,
      comments: comments ?? this.comments,
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
      'caption': caption,
      'otherUsers': otherUsers,
      'upvotes': upvotes,
      'commentCount': commentCount?.map((x) => x?.toMap())?.toList(),
      'comments': comments?.map((x) => x?.toMap())?.toList(),
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
      caption: map['caption'],
      otherUsers: List<String>.from(map['otherUsers']),
      upvotes: map['upvotes'],
      commentCount: List<Comment>.from(
          map['commentCount']?.map((x) => Comment.fromMap(x))),
      comments:
          List<Comment>.from(map['comments']?.map((x) => Comment.fromMap(x))),
      gpsTag: map['gpsTag'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Post.fromJson(String source) => Post.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Post(postId: $postId, userName: $userName, userAvatarLink: $userAvatarLink, datePosted: $datePosted, postImageLink: $postImageLink, caption: $caption, otherUsers: $otherUsers, upvotes: $upvotes, commentCount: $commentCount, comments: $comments, gpsTag: $gpsTag)';
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
        o.caption == caption &&
        listEquals(o.otherUsers, otherUsers) &&
        o.upvotes == upvotes &&
        listEquals(o.commentCount, commentCount) &&
        listEquals(o.comments, comments) &&
        o.gpsTag == gpsTag;
  }

  @override
  int get hashCode {
    return postId.hashCode ^
        userName.hashCode ^
        userAvatarLink.hashCode ^
        datePosted.hashCode ^
        postImageLink.hashCode ^
        caption.hashCode ^
        otherUsers.hashCode ^
        upvotes.hashCode ^
        commentCount.hashCode ^
        comments.hashCode ^
        gpsTag.hashCode;
  }
}
