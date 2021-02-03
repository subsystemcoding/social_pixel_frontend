import 'dart:convert';

// import 'package:hive/hive.dart';
// import 'package:hive_flutter/hive_flutter.dart';
import 'package:socialpixel/data/graphql_client.dart';

class AuthRepository {
  GraphqlClient client = GraphqlClient();
  String token;
  String refreshToken;

  AuthRepository._internal();

  static final _singleton = AuthRepository._internal();

  factory AuthRepository() => _singleton;

  Future<dynamic> authorizeLogin({String username, String password}) async {
    var response = await client.query('''
    mutation {
      tokenAuth(username: "$username", password: "$password" ) {
        success,
        errors,
        token,
        refreshToken,
      }
    }
    ''');
    print("Printing response from login");
    print(response);

    var jsonResponse = jsonDecode(response)['data']['tokenAuth'];
    if (jsonResponse['success']) {
      this.token = jsonResponse['token'];
      this.refreshToken = jsonResponse['refreshToken'];
      return {
        'success': true,
      };
    } else {
      return {
        'success': false,
        'errors': jsonResponse['errors'],
      };
    }
  }

  Future<dynamic> refreshTokenQuery(String refreshToken) async {
    var response = await client.query('''
    mutation {
      refreshToken(
        refreshToken: "$refreshToken"
      ) {
        success,
        errors,
        token,
        refreshToken,
      }
    }
    ''');

    var jsonResponse = jsonDecode(response)['data']['refreshToken'];
    if (jsonResponse['success']) {
      this.token = jsonResponse['token'];
      this.refreshToken = jsonResponse['refreshToken'];
      return {
        'success': true,
      };
    } else {
      return {
        'success': false,
        'errors': jsonResponse['errors'],
      };
    }
  }

  Future<dynamic> authorizeRegister(
      {String email,
      String username,
      String password1,
      String password2}) async {
    var response = await client.query(''' 
    mutation {
      register(
        email: "$email",
        username: "$username",
        password1: "$password1",
        password2: "$password2",
      ) {
        success,
        errors,
        token,
        refreshToken
      }
    }
    ''');

    var jsonResponse = jsonDecode(response)['data']['register'];
    bool success = jsonResponse['success'];
    if (success) {
      this.token = jsonResponse['token'];
      this.refreshToken = jsonResponse['refreshToken'];
      return {
        'success': true,
      };
    } else {
      return {'success': false, 'errors': jsonResponse['errors']};
    }
  }

  Future<bool> verifyAccount(String token) async {
    var response = await client.query('''
    mutation {
      verifyAccount(token: $token) {
        success,
        errors
      }
    }
    ''');

    return jsonDecode(response)['data']['verifyAccount']['success'];
  }
}
