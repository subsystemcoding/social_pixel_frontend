import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:socialpixel/data/repos/auth_repository.dart';
import 'package:socialpixel/data/repos/message_managament.dart';
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
    if (event is LoginWithHive) {
      final authObject = await AuthRepository().getAuth();
      if (authObject != null) {
        var response = await _authRepository.authorizeLogin(
          username: authObject.username ?? '',
          password: authObject.password ?? '',
        );

        if (response['success']) {
          Timer.periodic(Duration(seconds: 1),
              (timer) => MessageManagement().fetchMessages());
          yield LoginSuccessful();
        } else {
          yield AuthInitial();
        }
      } else {
        yield AuthInitial();
      }
    } else if (event is Login) {
      var response = await _authRepository.authorizeLogin(
        username: event.username,
        password: event.password,
      );
      if (response['success']) {
        Timer.periodic(Duration(seconds: 1),
            (timer) => MessageManagement().fetchMessages());
        yield LoginSuccessful();
      } else {
        yield LoginUnsuccessful(response['errors']);
      }
    } else if (event is Register) {
      var response = await _authRepository.authorizeRegister(
        username: event.username,
        email: event.email,
        password1: event.password1,
        password2: event.password2,
      );

      if (response['success']) {
        yield RegistrationSuccessful();
      } else {
        yield RegistrationUnsuccessful(response['errors']);
      }
    }
    // TODO: implement mapEventToState
  }
}
