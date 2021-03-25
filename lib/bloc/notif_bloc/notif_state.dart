part of 'notif_bloc.dart';

@immutable
abstract class NotifState {}

class NotifInitial extends NotifState {
  NotifInitial();
}

class NotifLoading extends NotifState {
  NotifLoading();
}

class NotifLoaded extends NotifState {
  final List<Notif> notifs;
  NotifLoaded(this.notifs);
}

class NotifError extends NotifState {
  final String message;
  NotifError(this.message);
}
