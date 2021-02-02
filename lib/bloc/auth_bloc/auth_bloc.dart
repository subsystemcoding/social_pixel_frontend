import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:socialpixel/data/repos/auth_repository.dart';
import 'package:socialpixel/data/repos/profile_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthRepository _authRepository = AuthRepository();
  AuthBloc() : super(AuthInitial());

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    yield AuthWait();
    if (event is Login) {
      var response = await _authRepository.authorizeLogin();
      if (response['success']) {
        yield LoginSuccessful();
      } else {
        yield LoginUnsuccessful();
      }
    } else if (event is Register) {
      var response = await _authRepository.authorizeRegister(
        username: event.username,
        email: event.username,
        password1: event.password1,
        password2: event.password2,
      );

      if (response['success']) {
        yield RegistrationSuccessful();
      } else {
        yield RegistrationUnsuccessful();
      }
    }
    // TODO: implement mapEventToState
  }
}
