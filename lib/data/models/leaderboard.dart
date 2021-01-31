import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:socialpixel/data/models/profile.dart';

class LeaderboardRow {
  Profile user;
  int points;
  LeaderboardRow({
    this.user,
    this.points,
  });

  LeaderboardRow copyWith({
    Profile user,
    int points,
  }) {
    return LeaderboardRow(
      user: user ?? this.user,
      points: points ?? this.points,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user': user?.toMap(),
      'points': points,
    };
  }

  factory LeaderboardRow.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return LeaderboardRow(
      user: Profile.fromMap(map['user']),
      points: map['points'],
    );
  }

  String toJson() => json.encode(toMap());

  factory LeaderboardRow.fromJson(String source) =>
      LeaderboardRow.fromMap(json.decode(source));

  @override
  String toString() => 'LeaderboardRow(user: $user, points: $points)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is LeaderboardRow && o.user == user && o.points == points;
  }

  @override
  int get hashCode => user.hashCode ^ points.hashCode;
}

class Leaderboard {
  int leaderboardId;
  List<LeaderboardRow> rows;
  Leaderboard({
    this.leaderboardId,
    this.rows,
  });

  Leaderboard copyWith({
    int leaderboardId,
    List<LeaderboardRow> rows,
  }) {
    return Leaderboard(
      leaderboardId: leaderboardId ?? this.leaderboardId,
      rows: rows ?? this.rows,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'leaderboardId': leaderboardId,
      'rows': rows?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory Leaderboard.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Leaderboard(
      leaderboardId: map['leaderboardId'],
      rows: List<LeaderboardRow>.from(
          map['rows']?.map((x) => LeaderboardRow.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Leaderboard.fromJson(String source) =>
      Leaderboard.fromMap(json.decode(source));

  @override
  String toString() =>
      'Leaderboard(leaderboardId: $leaderboardId, rows: $rows)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Leaderboard &&
        o.leaderboardId == leaderboardId &&
        listEquals(o.rows, rows);
  }

  @override
  int get hashCode => leaderboardId.hashCode ^ rows.hashCode;
}
