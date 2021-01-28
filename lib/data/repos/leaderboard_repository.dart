import 'dart:math';

import 'package:socialpixel/data/models/leaderboard.dart';
import 'package:english_words/english_words.dart';

class LeaderboardRepository {
  LeaderboardRepository();

  Future<Leaderboard> fetchLeaderboard({int ids = 20}) {
    var randomNumbers = [];
    for (int i = 0; i < ids; i++) {
      randomNumbers.add(i);
    }

    return Future.delayed(
      Duration(seconds: 1),
      () {
        return Leaderboard(
            gameId: 1,
            rows: randomNumbers.map((id) {
              return LeaderboardRow(
                userId: id,
                userAvatar: "https://picsum.photos/300/300",
                userName: generateWordPairs().take(1).first.asCamelCase,
                points: Random().nextInt(1000),
              );
            }).toList());
      },
    );
  }

  Leaderboard fetchLeaderboardSync({int ids = 20}) {
    var randomNumbers = [];
    for (int i = 0; i < ids; i++) {
      randomNumbers.add(i);
    }
    var leaderboard = Leaderboard(
      gameId: 1,
      rows: randomNumbers.map((id) {
        return LeaderboardRow(
          userId: id,
          userAvatar:
              "https://i.picsum.photos/id/691/200/300.jpg?hmac=1nouilaOHm3p-SqXPrCLcCcFEtJ60GlDAwkLAHq4x-c",
          userName: generateWordPairs().take(1).first.asCamelCase,
          points: Random().nextInt(1000),
        );
      }).toList(),
    );
    return sort(leaderboard);
  }

  Leaderboard sort(Leaderboard leaderboard) {
    leaderboard.rows.sort((a, b) => b.points.compareTo(a.points));
    return leaderboard;
  }
}
