part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class Login extends AuthEvent {
  final String username;
  final String password;
  Login({this.username, this.password});
}

class Register extends AuthEvent {
  final String username;
  final String email;
  final String password1;
  final String password2;
  Register({
    this.username,
    this.email,
    this.password1,
    this.password2,
  });
}
