part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class LoginSuccessful extends AuthState {}

class LoginUnsuccessful extends AuthState {
  final Map<String, dynamic> errors;

  LoginUnsuccessful(this.errors);
}

class RegistrationSuccessful extends AuthState {}

class RegistrationUnsuccessful extends AuthState {
  final Map<String, dynamic> errors;

  RegistrationUnsuccessful(this.errors);
}

class AuthWait extends AuthState {}

class AuthError extends AuthState {}
