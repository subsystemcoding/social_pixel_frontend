import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:socialpixel/data/models/notif.dart';
import 'package:socialpixel/data/repos/notif_repo.dart';

part 'notif_event.dart';
part 'notif_state.dart';

class NotifBloc extends Bloc<NotifEvent, NotifState> {
  NotifBloc() : super(NotifInitial());
  final notifManagement = NotifManagement();

  @override
  Stream<NotifState> mapEventToState(
    NotifEvent event,
  ) async* {
    yield NotifLoading();
    if (event is GetNotif) {
      final notifications = await notifManagement.fetchNotifs();
      yield NotifLoaded(notifications);
    }
    // TODO: implement mapEventToState
  }
}
