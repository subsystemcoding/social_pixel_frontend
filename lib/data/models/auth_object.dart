import 'package:hive/hive.dart';

part 'auth_object.g.dart';

@HiveType(typeId: 7)
class AuthObject {
  @HiveField(0)
  String username;
  @HiveField(1)
  String email;
  @HiveField(2)
  String password;
  @HiveField(3)
  String token;
  @HiveField(4)
  String refreshToken;
}
