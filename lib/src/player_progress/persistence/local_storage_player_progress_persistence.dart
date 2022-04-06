import 'package:shared_preferences/shared_preferences.dart';
import 'package:tictactoe/src/games_services/score.dart';
import 'package:tictactoe/src/player_progress/persistence/player_progress_persistence.dart';

class LocalStoragePlayerProgressPersistence extends PlayerProgressPersistence {
  final Future<SharedPreferences> instanceFuture =
      SharedPreferences.getInstance();

  @override
  Future<int> getHighestLevelReached() async {
    final prefs = await instanceFuture;
    return prefs.getInt('highestLevelReached') ?? 0;
  }

  @override
  Future<List<Score>> getHighestScores() async {
    // TODO: implement getHighestScores
    return <Score>[];
  }

  @override
  Future<void> saveHighestLevelReached(int level) async {
    final prefs = await instanceFuture;
    await prefs.setInt('highestLevelReached', level);
  }

  @override
  Future<void> saveHighestScores(List<Score> scores) async {
    // TODO: implement saveHighestScores
    return;
  }
}
