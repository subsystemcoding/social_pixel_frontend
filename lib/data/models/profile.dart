import 'dart:convert';

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
    );
  }

  String toJson() => json.encode(toMap());

  factory Profile.fromJson(String source) =>
      Profile.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Profile(userId: $userId, username: $username, userAvatarImage: $userAvatarImage, userCoverImage: $userCoverImage, email: $email, description: $description, points: $points, followers: $followers, createDate: $createDate, isVerified: $isVerified)';
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
        o.isVerified == isVerified;
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
        isVerified.hashCode;
  }
}
