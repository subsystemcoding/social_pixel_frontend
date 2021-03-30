part of 'leaderboard_bloc.dart';

@immutable
abstract class LeaderboardEvent {}

class GetLeaderboard extends LeaderboardEvent {
  final int gameId;

  GetLeaderboard(this.gameId);
}

class SubscribeToGame extends LeaderboardEvent {
  final int gameId;

  SubscribeToGame(this.gameId);
}
