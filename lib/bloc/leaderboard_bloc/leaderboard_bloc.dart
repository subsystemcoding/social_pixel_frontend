import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:socialpixel/data/models/leaderboard.dart';
import 'package:socialpixel/data/repos/leaderboard_repository.dart';

part 'leaderboard_event.dart';
part 'leaderboard_state.dart';

class LeaderboardBloc extends Bloc<LeaderboardEvent, LeaderboardState> {
  LeaderboardRepository repo = LeaderboardRepository();
  LeaderboardBloc() : super(LeaderboardInitial());

  @override
  Stream<LeaderboardState> mapEventToState(
    LeaderboardEvent event,
  ) async* {
    yield LeaderboardLoading();
    try {
      if (event is GetLeaderboard) {
        Leaderboard leaderboard = await repo.fetchLeaderboard(event.gameId);
        yield LeaderboardLoaded(leaderboard);
      }
    } catch (e) {
      print(e);
      yield LeaderboardError(e);
    }
    // TODO: implement mapEventToState
  }
}
