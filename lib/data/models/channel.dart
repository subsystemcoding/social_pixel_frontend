import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import 'package:socialpixel/data/models/game.dart';

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
  final int subscribers;
  @HiveField(4)
  final String coverImageLink;
  @HiveField(5)
  final String avatarImageLink;
  @HiveField(6)
  final List<Game> games;

  Channel({
    this.id,
    this.name,
    this.description,
    this.subscribers,
    this.coverImageLink,
    this.avatarImageLink,
    this.games,
  });

  Channel copyWith({
    int id,
    String name,
    String description,
    int subscribers,
    String coverImageLink,
    String avatarImageLink,
    List<Game> games,
  }) {
    return Channel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      subscribers: subscribers ?? this.subscribers,
      coverImageLink: coverImageLink ?? this.coverImageLink,
      avatarImageLink: avatarImageLink ?? this.avatarImageLink,
      games: games ?? this.games,
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
      'games': games?.map((x) => x.toMap())?.toList(),
    };
  }

  factory Channel.fromMap(Map<String, dynamic> map) {
    return Channel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      subscribers: map['subscribers'],
      coverImageLink: map['coverImageLink'],
      avatarImageLink: map['avatarImageLink'],
      games: List<Game>.from(map['games']?.map((x) => Game.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Channel.fromJson(String source) =>
      Channel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Channel(id: $id, name: $name, description: $description, subscribers: $subscribers, coverImageLink: $coverImageLink, avatarImageLink: $avatarImageLink, games: $games)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Channel &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.subscribers == subscribers &&
        other.coverImageLink == coverImageLink &&
        other.avatarImageLink == avatarImageLink &&
        listEquals(other.games, games);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        subscribers.hashCode ^
        coverImageLink.hashCode ^
        avatarImageLink.hashCode ^
        games.hashCode;
  }
}
