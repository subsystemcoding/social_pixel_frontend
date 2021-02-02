import 'dart:convert';
import 'dart:typed_data';

import 'package:hive/hive.dart';

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
      //'userImageBytes': userImageBytes?.toMap(),
      //'userCoverImageBytes': userCoverImageBytes?.toMap(),
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
      //userImageBytes: Uint8List.fromMap(map['userImageBytes']),
      //userCoverImageBytes: Uint8List.fromMap(map['userCoverImageBytes']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Profile.fromJson(String source) =>
      Profile.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Profile(userId: $userId, username: $username, userAvatarImage: $userAvatarImage, userCoverImage: $userCoverImage, email: $email, description: $description, points: $points, followers: $followers, createDate: $createDate, isVerified: $isVerified, userImageBytes: $userImageBytes, userCoverImageBytes: $userCoverImageBytes)';
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
        o.userCoverImageBytes == userCoverImageBytes;
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
        userCoverImageBytes.hashCode;
  }
}
