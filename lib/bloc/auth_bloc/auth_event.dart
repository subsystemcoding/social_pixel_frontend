part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class Login extends AuthEvent {
  final String email;
  final String password;
  Login({this.email, this.password});
}

class Register extends AuthEvent {
  final String username;
  final String email;
  final String password;
  Register({
    this.username,
    this.email,
    this.password,
  });
}
