part of 'leaderboard_bloc.dart';

@immutable
abstract class LeaderboardState {}

class LeaderboardInitial extends LeaderboardState {}

class LeaderboardLoading extends LeaderboardState {}

class LeaderboardLoaded extends LeaderboardState {
  final Leaderboard leaderboard;

  LeaderboardLoaded(this.leaderboard);
}

class GameSubscribed extends LeaderboardState {}

class LeaderboardError extends LeaderboardState {
  final String message;
  LeaderboardError(this.message);
}
