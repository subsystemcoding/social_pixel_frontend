import 'dart:convert';

// import 'package:hive/hive.dart';
// import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:socialpixel/data/graphql_client.dart';
import 'package:socialpixel/data/models/auth_object.dart';

class AuthRepository {
  GraphqlClient client = GraphqlClient();
  String hiveBox = "auth";

  AuthRepository._internal();

  static final _singleton = AuthRepository._internal();

  factory AuthRepository() => _singleton;

  Future<dynamic> authorizeLogin({String username, String password}) async {
    if (username == null && password == null) {
      AuthObject authObject = await _fetchAuthDetails();
      if (authObject == null) {
        return {
          'success': false,
        };
      }
      username = authObject.username;
      password = authObject.password;
    }
    var response = await client.query('''
    mutation {
      tokenAuth(username: "$username", password: "$password" ) {
        success,
        errors,
        token,
        refreshToken,
      }
    }
    ''', token: false);
    print("Printing response from login");
    print(response);

    var jsonResponse = jsonDecode(response)['data']['tokenAuth'];
    if (jsonResponse['success']) {
      //save the details to the cache
      AuthObject authObject = await _fetchAuthDetails();
      authObject = authObject ?? AuthObject();
      authObject.username = username;
      authObject.password = password;
      authObject.token = jsonResponse['token'];
      authObject.refreshToken = jsonResponse['refreshToken'];
      _saveToHive(authObject);

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
    ''', token: false);

    var jsonResponse = jsonDecode(response)['data']['refreshToken'];
    if (jsonResponse['success']) {
      AuthObject authObject = await _fetchAuthDetails();
      authObject.token = jsonResponse['token'];
      authObject.refreshToken = jsonResponse['refreshToken'];
      _saveToHive(authObject);
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
    ''', token: false);

    var jsonResponse = jsonDecode(response)['data']['register'];
    bool success = jsonResponse['success'];
    if (success) {
      AuthObject authObject = await _fetchAuthDetails();
      authObject = authObject ?? AuthObject();
      authObject.username = username;
      authObject.password = password1;
      authObject.email = email;
      authObject.token = jsonResponse['token'];
      authObject.refreshToken = jsonResponse['refreshToken'];
      _saveToHive(authObject);
      return {
        'success': true,
      };
    } else {
      return {'success': false, 'errors': jsonResponse['errors']};
    }
  }

  Future<AuthObject> getAuth() async {
    final box = await Hive.openBox(hiveBox);
    AuthObject authObject = box.get(hiveBox);
    return authObject;
  }

  Future<bool> verifyAccount(String token) async {
    var response = await client.query('''
    mutation {
      verifyAccount(token: $token) {
        success,
        errors
      }
    }
    ''', token: false);

    return jsonDecode(response)['data']['verifyAccount']['success'];
  }

  Future<void> _saveToHive(AuthObject authObject) async {
    final box = await Hive.openBox(hiveBox);
    box.put(
      hiveBox,
      authObject,
    );
  }

  Future<AuthObject> _fetchAuthDetails() async {
    final box = await Hive.openBox(hiveBox);
    AuthObject map = box.get(hiveBox);
    return map;
  }
}
