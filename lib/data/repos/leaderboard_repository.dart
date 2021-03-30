import 'dart:convert';
import 'dart:math';

import 'package:socialpixel/data/graphql_client.dart';
import 'package:socialpixel/data/models/leaderboard.dart';
import 'package:english_words/english_words.dart';
import 'package:socialpixel/data/models/profile.dart';
import 'package:socialpixel/data/test_data/test_data.dart';

class LeaderboardRepository {
  LeaderboardRepository();

  Future<Leaderboard> fetchLeaderboard(int gameId) async {
    var response = await GraphqlClient().query('''
    query{
      game(id: $gameId){
        leaderboard{
          leaderboardrowSet{
            user{
              user{
                username
              }
              image
            }
            points
          }
        }
      }
    }
    ''');
    var jsonResponse = jsonDecode(response)['data']['game']['leaderboard']
        ['leaderboardrowSet'];
    return Leaderboard(
      rows: List<LeaderboardRow>.from(
        jsonResponse?.map(
          (item) => LeaderboardRow(
            points: int.parse(item['points']),
            user: Profile(
                username: item['user']['username'],
                userAvatarImage: item['image']),
          ),
        ),
      ),
    );
  }

  Future<bool> subscribeToGame(int gameId) {}

  Leaderboard sort(Leaderboard leaderboard) {
    leaderboard.rows.sort((a, b) => b.points.compareTo(a.points));
    return leaderboard;
  }
}
