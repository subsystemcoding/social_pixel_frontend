import 'dart:convert';

import 'package:socialpixel/data/graphql_client.dart';

class GameRepository {
  static final GameRepository _singleton = GameRepository._internal();

  factory GameRepository() {
    return _singleton;
  }

  GameRepository._internal();

  Future<bool> createGame(
    String channelName,
    String gameName,
    String description,
    String gameImagePath,
    List<int> postIds,
  ) async {
    var response = await GraphqlClient().muiltiPartRequest(fields: {
      'query': '''
          createGame(channel:"$channelName", description: "$description", gameImage: "gameImagePath", name: "$gameName", posts: ${postIds.toString()}){
            success
          }'''
    }, files: {
      'gameImagePath': gameImagePath,
    });

    return jsonDecode(response)['data']['createGame']['success'];
  }
}
