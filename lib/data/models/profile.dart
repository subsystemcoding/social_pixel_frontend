import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import 'package:socialpixel/data/models/channel.dart';
import 'package:socialpixel/data/models/game.dart';

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
  final int followers;
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
      // 'userImageBytes': userImageBytes.toMap(),
      // 'userCoverImageBytes': userCoverImageBytes.toMap(),
      'subscribedGames': subscribedGames?.map((x) => x.toMap())?.toList(),
      'subscribedChannels': subscribedChannels?.map((x) => x.toMap())?.toList(),
    };
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
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
    );
  }

  String toJson() => json.encode(toMap());

  factory Profile.fromJson(String source) =>
      Profile.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Profile(userId: $userId, username: $username, userAvatarImage: $userAvatarImage, userCoverImage: $userCoverImage, email: $email, description: $description, points: $points, followers: $followers, createDate: $createDate, isVerified: $isVerified, userImageBytes: $userImageBytes, userCoverImageBytes: $userCoverImageBytes, subscribedGames: $subscribedGames, subscribedChannels: $subscribedChannels)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Profile &&
        other.userId == userId &&
        other.username == username &&
        other.userAvatarImage == userAvatarImage &&
        other.userCoverImage == userCoverImage &&
        other.email == email &&
        other.description == description &&
        other.points == points &&
        other.followers == followers &&
        other.createDate == createDate &&
        other.isVerified == isVerified &&
        other.userImageBytes == userImageBytes &&
        other.userCoverImageBytes == userCoverImageBytes &&
        listEquals(other.subscribedGames, subscribedGames) &&
        listEquals(other.subscribedChannels, subscribedChannels);
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
        subscribedChannels.hashCode;
  }
}
