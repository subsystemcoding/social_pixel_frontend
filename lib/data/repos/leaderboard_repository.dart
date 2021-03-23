import 'dart:convert';
import 'dart:math';

import 'package:socialpixel/data/models/leaderboard.dart';
import 'package:english_words/english_words.dart';
import 'package:socialpixel/data/test_data/test_data.dart';

class LeaderboardRepository {
  LeaderboardRepository();

  Future<Leaderboard> fetchLeaderboard(int leaderboardId) {
    return Future.delayed(
      Duration(milliseconds: 100),
      () {
        return Future.delayed(
          Duration(milliseconds: 100),
          () {
            String jsonData = TestData.leaderboardData();

            Leaderboard leaderboard = Leaderboard.fromJson(jsonData);

            return sort(leaderboard);
          },
        );
      },
    );
  }

  Leaderboard sort(Leaderboard leaderboard) {
    leaderboard.rows.sort((a, b) => b.points.compareTo(a.points));
    return leaderboard;
  }
}
