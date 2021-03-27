import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:socialpixel/data/repos/auth_repository.dart';

//This is a singleton class
class GraphqlClient {
  final client = http.Client();
  final url = 'http://localhost:8000/graphql';
  Uri uri = Uri.http('localhost:8000', '/graphql');

  GraphqlClient._internal();

  static final _singleton = GraphqlClient._internal();

  factory GraphqlClient() => _singleton;

  Future<String> query(String query, {bool token = true}) async {
    String auth = '';
    if (token) {
      final authObject = await AuthRepository().getAuth();
      String tokenString = authObject.token;
      auth = 'JWT $tokenString';
    }
    try {
      var response = await this.client.post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              "Accept": "application/json",
              "Authorization": auth,
            },
            body: jsonEncode({'query': query}),
          );

      print(response.body.toString());
      return response.body;
    } catch (e) {
      print("Priniting Error");
      print(e);
      return null;
    }
  }
}
