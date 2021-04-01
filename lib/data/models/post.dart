import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import 'package:socialpixel/data/models/comment.dart';
import 'package:socialpixel/data/models/profile.dart';

import 'channel.dart';
import 'location.dart';

part 'post.g.dart';

@HiveType(typeId: 0)
class Post {
  @HiveField(0)
  final int postId;
  @HiveField(1)
  final String userName;
  @HiveField(2)
  final String userAvatarLink;
  @HiveField(3)
  final String datePosted;
  @HiveField(4)
  final String postImageLink;
  @HiveField(5)
  final String caption;
  @HiveField(6)
  final List<Profile> otherUsers;
  @HiveField(7)
  int upvotes;
  @HiveField(8)
  int commentCount;
  @HiveField(9)
  List<Comment> comments;
  @HiveField(10)
  final Location location;
  @HiveField(11)
  Uint8List userImageBytes;
  @HiveField(12)
  Uint8List postImageBytes;
  @HiveField(13)
  bool isUpvoted;
  @HiveField(14)
  Channel channel;

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
    this.location,
    this.userImageBytes,
    this.postImageBytes,
    this.isUpvoted,
    this.channel,
  });

  Post copyWith({
    int postId,
    String userName,
    String userAvatarLink,
    String datePosted,
    String postImageLink,
    String caption,
    List<Profile> otherUsers,
    int upvotes,
    int commentCount,
    List<Comment> comments,
    Location location,
    Uint8List userImageBytes,
    Uint8List postImageBytes,
    bool isUpvoted,
    Channel channel,
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
      location: location ?? this.location,
      userImageBytes: userImageBytes ?? this.userImageBytes,
      postImageBytes: postImageBytes ?? this.postImageBytes,
      isUpvoted: isUpvoted ?? this.isUpvoted,
      channel: channel ?? this.channel,
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
      'otherUsers': otherUsers?.map((x) => x?.toMap())?.toList(),
      'upvotes': upvotes,
      'commentCount': commentCount,
      'comments': comments?.map((x) => x?.toMap())?.toList(),
      'location': location?.toMap(),
      // 'userImageBytes': userImageBytes?.toMap(),
      // 'postImageBytes': postImageBytes?.toMap(),
      'isUpvoted': isUpvoted,
      'channel': channel?.toMap(),
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
      otherUsers: map['otherUsers'] == null || map['otherUsers'].isEmpty
          ? []
          : List<Profile>.from(
              map['otherUsers']?.map((x) => Profile.fromMap(x))),
      upvotes: map['upvotes'],
      commentCount: map['commentCount'],
      comments: [],
      location: Location.fromMap(map['location']),
      // userImageBytes: Uint8List.fromMap(map['userImageBytes']),
      // postImageBytes: Uint8List.fromMap(map['postImageBytes']),
      isUpvoted: map['isUpvoted'],
      channel: Channel.fromMap(map['channel']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Post.fromJson(String source) => Post.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Post(postId: $postId, userName: $userName, userAvatarLink: $userAvatarLink, datePosted: $datePosted, postImageLink: $postImageLink, caption: $caption, otherUsers: $otherUsers, upvotes: $upvotes, commentCount: $commentCount, comments: $comments, location: $location, userImageBytes: $userImageBytes, postImageBytes: $postImageBytes, isUpvoted: $isUpvoted, channel: $channel)';
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
        o.commentCount == commentCount &&
        listEquals(o.comments, comments) &&
        o.location == location &&
        o.userImageBytes == userImageBytes &&
        o.postImageBytes == postImageBytes &&
        o.isUpvoted == isUpvoted &&
        o.channel == channel;
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
        location.hashCode ^
        userImageBytes.hashCode ^
        postImageBytes.hashCode ^
        isUpvoted.hashCode ^
        channel.hashCode;
  }
}
