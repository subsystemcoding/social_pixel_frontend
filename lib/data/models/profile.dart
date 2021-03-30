import 'dart:convert';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import 'package:socialpixel/data/models/channel.dart';
import 'package:socialpixel/data/models/chatroom.dart';
import 'package:socialpixel/data/models/game.dart';
import 'package:socialpixel/data/models/post.dart';

part 'profile.g.dart';

@HiveType(typeId: 1)
class Profile {
  @HiveField(0)
  final int userId;
  @HiveField(1)
  final String username;
  @HiveField(2)
  final String userAvatarImage;
  @HiveField(3)
  final String userCoverImage;
  @HiveField(4)
  final String email;
  @HiveField(5)
  final String description;
  @HiveField(6)
  final int points;
  @HiveField(7)
  int followers;
  @HiveField(8)
  final String createDate;
  @HiveField(9)
  final bool isVerified;
  @HiveField(10)
  final Uint8List userImageBytes;
  @HiveField(11)
  final Uint8List userCoverImageBytes;
  @HiveField(12)
  final List<Game> subscribedGames;
  @HiveField(13)
  final List<Channel> subscribedChannels;
  @HiveField(14)
  final List<Post> postsMade;
  @HiveField(15)
  final List<Post> upvotedPosts;
  @HiveField(16)
  bool isFollowing;
  @HiveField(17)
  List<Chatroom> chatrooms;
  Profile({
    this.userId,
    this.username,
    this.userAvatarImage,
    this.userCoverImage,
    this.email,
    this.description,
    this.points,
    this.followers,
    this.createDate,
    this.isVerified,
    this.userImageBytes,
    this.userCoverImageBytes,
    this.subscribedGames,
    this.subscribedChannels,
    this.postsMade,
    this.upvotedPosts,
    this.isFollowing,
    this.chatrooms,
  });

  Profile copyWith({
    int userId,
    String username,
    String userAvatarImage,
    String userCoverImage,
    String email,
    String description,
    int points,
    int followers,
    String createDate,
    bool isVerified,
    Uint8List userImageBytes,
    Uint8List userCoverImageBytes,
    List<Game> subscribedGames,
    List<Channel> subscribedChannels,
    List<Post> postsMade,
    List<Post> upvotedPosts,
    bool isFollowing,
    List<Chatroom> chatrooms,
  }) {
    return Profile(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      userAvatarImage: userAvatarImage ?? this.userAvatarImage,
      userCoverImage: userCoverImage ?? this.userCoverImage,
      email: email ?? this.email,
      description: description ?? this.description,
      points: points ?? this.points,
      followers: followers ?? this.followers,
      createDate: createDate ?? this.createDate,
      isVerified: isVerified ?? this.isVerified,
      userImageBytes: userImageBytes ?? this.userImageBytes,
      userCoverImageBytes: userCoverImageBytes ?? this.userCoverImageBytes,
      subscribedGames: subscribedGames ?? this.subscribedGames,
      subscribedChannels: subscribedChannels ?? this.subscribedChannels,
      postsMade: postsMade ?? this.postsMade,
      upvotedPosts: upvotedPosts ?? this.upvotedPosts,
      isFollowing: isFollowing ?? this.isFollowing,
      chatrooms: chatrooms ?? this.chatrooms,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
      'userAvatarImage': userAvatarImage,
      'userCoverImage': userCoverImage,
      'email': email,
      'description': description,
      'points': points,
      'followers': followers,
      'createDate': createDate,
      'isVerified': isVerified,
      // 'userImageBytes': userImageBytes?.toMap(),
      // 'userCoverImageBytes': userCoverImageBytes?.toMap(),
      'subscribedGames': subscribedGames?.map((x) => x?.toMap())?.toList(),
      'subscribedChannels':
          subscribedChannels?.map((x) => x?.toMap())?.toList(),
      'postsMade': postsMade?.map((x) => x?.toMap())?.toList(),
      'upvotedPosts': upvotedPosts?.map((x) => x?.toMap())?.toList(),
      'isFollowing': isFollowing,
      'chatrooms': chatrooms?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Profile(
      userId: map['userId'],
      username: map['username'],
      userAvatarImage: map['userAvatarImage'],
      userCoverImage: map['userCoverImage'],
      email: map['email'],
      description: map['description'],
      points: map['points'],
      followers: map['followers'],
      createDate: map['createDate'],
      isVerified: map['isVerified'],
      // userImageBytes: Uint8List.fromMap(map['userImageBytes']),
      // userCoverImageBytes: Uint8List.fromMap(map['userCoverImageBytes']),
      subscribedGames:
          List<Game>.from(map['subscribedGames']?.map((x) => Game.fromMap(x))),
      subscribedChannels: List<Channel>.from(
          map['subscribedChannels']?.map((x) => Channel.fromMap(x))),
      postsMade: List<Post>.from(map['postsMade']?.map((x) => Post.fromMap(x))),
      upvotedPosts:
          List<Post>.from(map['upvotedPosts']?.map((x) => Post.fromMap(x))),
      isFollowing: map['isFollowing'],
      chatrooms: List<Chatroom>.from(
          map['chatrooms']?.map((x) => Chatroom.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Profile.fromJson(String source) =>
      Profile.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Profile(userId: $userId, username: $username, userAvatarImage: $userAvatarImage, userCoverImage: $userCoverImage, email: $email, description: $description, points: $points, followers: $followers, createDate: $createDate, isVerified: $isVerified, userImageBytes: $userImageBytes, userCoverImageBytes: $userCoverImageBytes, subscribedGames: $subscribedGames, subscribedChannels: $subscribedChannels, postsMade: $postsMade, upvotedPosts: $upvotedPosts, isFollowing: $isFollowing, chatrooms: $chatrooms)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Profile &&
        o.userId == userId &&
        o.username == username &&
        o.userAvatarImage == userAvatarImage &&
        o.userCoverImage == userCoverImage &&
        o.email == email &&
        o.description == description &&
        o.points == points &&
        o.followers == followers &&
        o.createDate == createDate &&
        o.isVerified == isVerified &&
        o.userImageBytes == userImageBytes &&
        o.userCoverImageBytes == userCoverImageBytes &&
        listEquals(o.subscribedGames, subscribedGames) &&
        listEquals(o.subscribedChannels, subscribedChannels) &&
        listEquals(o.postsMade, postsMade) &&
        listEquals(o.upvotedPosts, upvotedPosts) &&
        o.isFollowing == isFollowing &&
        listEquals(o.chatrooms, chatrooms);
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        username.hashCode ^
        userAvatarImage.hashCode ^
        userCoverImage.hashCode ^
        email.hashCode ^
        description.hashCode ^
        points.hashCode ^
        followers.hashCode ^
        createDate.hashCode ^
        isVerified.hashCode ^
        userImageBytes.hashCode ^
        userCoverImageBytes.hashCode ^
        subscribedGames.hashCode ^
        subscribedChannels.hashCode ^
        postsMade.hashCode ^
        upvotedPosts.hashCode ^
        isFollowing.hashCode ^
        chatrooms.hashCode;
  }
}
