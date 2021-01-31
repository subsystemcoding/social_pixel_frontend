import 'dart:convert';

class Game {
  int gameId;
  String image;
  String name;
  String description;
  int leaderboardId;

  Game({
    this.gameId,
    this.image,
    this.name,
    this.description,
    this.leaderboardId,
  });

  Game copyWith({
    int gameId,
    String image,
    String name,
    String description,
    int leaderboardId,
  }) {
    return Game(
      gameId: gameId ?? this.gameId,
      image: image ?? this.image,
      name: name ?? this.name,
      description: description ?? this.description,
      leaderboardId: leaderboardId ?? this.leaderboardId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'gameId': gameId,
      'image': image,
      'name': name,
      'description': description,
      'leaderboardId': leaderboardId,
    };
  }

  factory Game.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Game(
      gameId: map['gameId'],
      image: map['image'],
      name: map['name'],
      description: map['description'],
      leaderboardId: map['leaderboardId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Game.fromJson(String source) => Game.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Game(gameId: $gameId, image: $image, name: $name, description: $description, leaderboardId: $leaderboardId)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Game &&
        o.gameId == gameId &&
        o.image == image &&
        o.name == name &&
        o.description == description &&
        o.leaderboardId == leaderboardId;
  }

  @override
  int get hashCode {
    return gameId.hashCode ^
        image.hashCode ^
        name.hashCode ^
        description.hashCode ^
        leaderboardId.hashCode;
  }
}
