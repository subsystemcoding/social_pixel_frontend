import 'dart:convert';

import 'package:flutter/foundation.dart';

class LeaderboardRow {
  int userId;
  String userAvatar;
  String userName;
  int points;
  LeaderboardRow({
    this.userId,
    this.userAvatar,
    this.userName,
    this.points,
  });

  LeaderboardRow copyWith({
    int userId,
    String userAvatar,
    String userName,
    int points,
  }) {
    return LeaderboardRow(
      userId: userId ?? this.userId,
      userAvatar: userAvatar ?? this.userAvatar,
      userName: userName ?? this.userName,
      points: points ?? this.points,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userAvatar': userAvatar,
      'userName': userName,
      'points': points,
    };
  }

  factory LeaderboardRow.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return LeaderboardRow(
      userId: map['userId'],
      userAvatar: map['userAvatar'],
      userName: map['userName'],
      points: map['points'],
    );
  }

  String toJson() => json.encode(toMap());

  factory LeaderboardRow.fromJson(String source) =>
      LeaderboardRow.fromMap(json.decode(source));

  @override
  String toString() {
    return 'LeaderboardRow(userId: $userId, userAvatar: $userAvatar, userName: $userName, points: $points)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is LeaderboardRow &&
        o.userId == userId &&
        o.userAvatar == userAvatar &&
        o.userName == userName &&
        o.points == points;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        userAvatar.hashCode ^
        userName.hashCode ^
        points.hashCode;
  }
}

class Leaderboard {
  int gameId;
  List<LeaderboardRow> rows;
  Leaderboard({
    this.gameId,
    this.rows,
  });

  Leaderboard copyWith({
    int gameId,
    List<LeaderboardRow> rows,
  }) {
    return Leaderboard(
      gameId: gameId ?? this.gameId,
      rows: rows ?? this.rows,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'gameId': gameId,
      'rows': rows?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory Leaderboard.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Leaderboard(
      gameId: map['gameId'],
      rows: List<LeaderboardRow>.from(
          map['rows']?.map((x) => LeaderboardRow.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Leaderboard.fromJson(String source) =>
      Leaderboard.fromMap(json.decode(source));

  @override
  String toString() => 'Leaderboard(gameId: $gameId, rows: $rows)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Leaderboard && o.gameId == gameId && listEquals(o.rows, rows);
  }

  @override
  int get hashCode => gameId.hashCode ^ rows.hashCode;
}
