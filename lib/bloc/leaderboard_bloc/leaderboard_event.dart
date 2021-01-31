part of 'leaderboard_bloc.dart';

@immutable
abstract class LeaderboardEvent {}

class GetLeaderboard extends LeaderboardEvent {
  final int leaderboardId;

  GetLeaderboard(this.leaderboardId);
}
