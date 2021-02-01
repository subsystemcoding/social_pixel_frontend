part of 'game_bloc.dart';

@immutable
abstract class GameEvent {}

class FetchGames extends GameEvent {
  final int channelId;

  FetchGames(this.channelId);
}
