import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import 'package:socialpixel/data/models/channel.dart';
import 'package:socialpixel/data/models/mapPost.dart';

part 'game.g.dart';

@HiveType(typeId: 6)
class Game {
  @HiveField(0)
  int gameId;
  @HiveField(1)
  String image;
  @HiveField(2)
  String name;
  @HiveField(3)
  String description;
  @HiveField(4)
  int leaderboardId;
  @HiveField(5)
  List<MapPost> mapPosts;
  @HiveField(6)
  String pinColorHex;
  @HiveField(7)
  Channel channel;

  Game({
    this.gameId,
    this.image,
    this.name,
    this.description,
    this.leaderboardId,
    this.mapPosts,
    this.pinColorHex,
    this.channel,
  });

  Game copyWith({
    int gameId,
    String image,
    String name,
    String description,
    int leaderboardId,
    List<MapPost> mapPosts,
    String pinColorHex,
    Channel channel,
  }) {
    return Game(
      gameId: gameId ?? this.gameId,
      image: image ?? this.image,
      name: name ?? this.name,
      description: description ?? this.description,
      leaderboardId: leaderboardId ?? this.leaderboardId,
      mapPosts: mapPosts ?? this.mapPosts,
      pinColorHex: pinColorHex ?? this.pinColorHex,
      channel: channel ?? this.channel,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'gameId': gameId,
      'image': image,
      'name': name,
      'description': description,
      'leaderboardId': leaderboardId,
      'mapPosts': mapPosts?.map((x) => x.toMap())?.toList(),
      'pinColorHex': pinColorHex,
      'channel': channel.toMap(),
    };
  }

  factory Game.fromMap(Map<String, dynamic> map) {
    return Game(
      gameId: map['gameId'],
      image: map['image'],
      name: map['name'],
      description: map['description'],
      leaderboardId: map['leaderboardId'],
      mapPosts: map.containsKey("mapPosts")
          ? List<MapPost>.from(map['mapPosts']?.map((x) => MapPost.fromMap(x)))
          : null,
      pinColorHex: map['pinColorHex'],
      channel:
          map.containsKey('channel') ? Channel.fromMap(map['channel']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Game.fromJson(String source) => Game.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Game(gameId: $gameId, image: $image, name: $name, description: $description, leaderboardId: $leaderboardId, mapPosts: $mapPosts, pinColorHex: $pinColorHex, channel: $channel)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Game &&
        other.gameId == gameId &&
        other.image == image &&
        other.name == name &&
        other.description == description &&
        other.leaderboardId == leaderboardId &&
        listEquals(other.mapPosts, mapPosts) &&
        other.pinColorHex == pinColorHex &&
        other.channel == channel;
  }

  @override
  int get hashCode {
    return gameId.hashCode ^
        image.hashCode ^
        name.hashCode ^
        description.hashCode ^
        leaderboardId.hashCode ^
        mapPosts.hashCode ^
        pinColorHex.hashCode ^
        channel.hashCode;
  }
}
