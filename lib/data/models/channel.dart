import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import 'package:socialpixel/data/models/game.dart';
import 'package:socialpixel/data/models/post.dart';

part 'channel.g.dart';

@HiveType(typeId: 5)
class Channel {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String description;
  @HiveField(3)
  int subscribers;
  @HiveField(4)
  final String coverImageLink;
  @HiveField(5)
  final String avatarImageLink;
  @HiveField(6)
  final List<Game> games;
  @HiveField(7)
  final List<Post> posts;
  @HiveField(8)
  bool isSubscribed;

  Channel({
    this.id,
    this.name,
    this.description,
    this.subscribers,
    this.coverImageLink,
    this.avatarImageLink,
    this.games,
    this.posts,
    this.isSubscribed,
  });

  Channel copyWith({
    int id,
    String name,
    String description,
    int subscribers,
    String coverImageLink,
    String avatarImageLink,
    List<Game> games,
    List<Post> posts,
    bool isSubscribed,
  }) {
    return Channel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      subscribers: subscribers ?? this.subscribers,
      coverImageLink: coverImageLink ?? this.coverImageLink,
      avatarImageLink: avatarImageLink ?? this.avatarImageLink,
      games: games ?? this.games,
      posts: posts ?? this.posts,
      isSubscribed: isSubscribed ?? this.isSubscribed,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'subscribers': subscribers,
      'coverImageLink': coverImageLink,
      'avatarImageLink': avatarImageLink,
      'games': games?.map((x) => x?.toMap())?.toList(),
      'posts': posts?.map((x) => x?.toMap())?.toList(),
      'isSubscribed': isSubscribed,
    };
  }

  factory Channel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Channel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      subscribers: map['subscribers'],
      coverImageLink: map['coverImageLink'],
      avatarImageLink: map['avatarImageLink'],
      games: List<Game>.from(map['games']?.map((x) => Game.fromMap(x))),
      posts: List<Post>.from(map['posts']?.map((x) => Post.fromMap(x))),
      isSubscribed: map['isSubscribed'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Channel.fromJson(String source) =>
      Channel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Channel(id: $id, name: $name, description: $description, subscribers: $subscribers, coverImageLink: $coverImageLink, avatarImageLink: $avatarImageLink, games: $games, posts: $posts, isSubscribed: $isSubscribed)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Channel &&
        o.id == id &&
        o.name == name &&
        o.description == description &&
        o.subscribers == subscribers &&
        o.coverImageLink == coverImageLink &&
        o.avatarImageLink == avatarImageLink &&
        listEquals(o.games, games) &&
        listEquals(o.posts, posts) &&
        o.isSubscribed == isSubscribed;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        subscribers.hashCode ^
        coverImageLink.hashCode ^
        avatarImageLink.hashCode ^
        games.hashCode ^
        posts.hashCode ^
        isSubscribed.hashCode;
  }
}
