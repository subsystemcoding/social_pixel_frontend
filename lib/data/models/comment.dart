import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import 'package:socialpixel/data/models/profile.dart';

part 'comment.g.dart';

@HiveType(typeId: 2)
class Comment {
  @HiveField(0)
  int commentId;
  @HiveField(1)
  String commentContent;
  @HiveField(2)
  List<Comment> replies;
  @HiveField(3)
  String dateCreated;
  @HiveField(4)
  Profile user;

  Comment({
    this.commentId,
    this.commentContent,
    this.replies,
    this.dateCreated,
    this.user,
  });

  Comment copyWith({
    int commentId,
    String commentContent,
    List<Comment> replies,
    String dateCreated,
    Profile user,
  }) {
    return Comment(
      commentId: commentId ?? this.commentId,
      commentContent: commentContent ?? this.commentContent,
      replies: replies ?? this.replies,
      dateCreated: dateCreated ?? this.dateCreated,
      user: user ?? this.user,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'commentId': commentId,
      'commentContent': commentContent,
      'replies': replies?.map((x) => x?.toMap())?.toList(),
      'dateCreated': dateCreated,
      'user': user?.toMap(),
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Comment(
      commentId: map['commentId'],
      commentContent: map['commentContent'],
      replies:
          List<Comment>.from(map['replies']?.map((x) => Comment.fromMap(x))),
      dateCreated: map['dateCreated'],
      user: Profile.fromMap(map['user']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Comment.fromJson(String source) =>
      Comment.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Comment(commentId: $commentId, commentContent: $commentContent, replies: $replies, dateCreated: $dateCreated, user: $user)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Comment &&
        o.commentId == commentId &&
        o.commentContent == commentContent &&
        listEquals(o.replies, replies) &&
        o.dateCreated == dateCreated &&
        o.user == user;
  }

  @override
  int get hashCode {
    return commentId.hashCode ^
        commentContent.hashCode ^
        replies.hashCode ^
        dateCreated.hashCode ^
        user.hashCode;
  }
}
