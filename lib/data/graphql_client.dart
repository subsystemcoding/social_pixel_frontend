import 'dart:convert';

import 'package:http/http.dart' as http;

//This is a singleton class
class GraphqlClient {
  final client = http.Client();
  final url = 'http://localhost:8000/api/graphql';

  GraphqlClient._internal();

  static final _singleton = GraphqlClient._internal();

  factory GraphqlClient() => _singleton;

  void query(String query) async {
    try {
      var response = await this.client.post(
            url,
            headers: {
              'Content-Type': 'application/json',
              "Accept": "application/json",
            },
            body: jsonEncode({"query": query}),
          );

      print(response.body.toString());
    } catch (e) {
      print(e);
    }
  }
}
