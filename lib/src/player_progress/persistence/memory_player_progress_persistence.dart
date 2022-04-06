import 'package:tictactoe/src/games_services/score.dart';
import 'package:tictactoe/src/player_progress/persistence/player_progress_persistence.dart';

class MemoryOnlyPlayerProgressPersistence implements PlayerProgressPersistence {
  int level = 0;

  List<Score> highestScores = [];

  @override
  Future<int> getHighestLevelReached() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return level;
  }

  @override
  Future<void> saveHighestLevelReached(int level) async {
    await Future.delayed(const Duration(milliseconds: 500));
    this.level = level;
  }

  @override
  Future<List<Score>> getHighestScores() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return highestScores;
  }

  @override
  Future<void> saveHighestScores(List<Score> scores) async {
    await Future.delayed(const Duration(milliseconds: 500));
    highestScores = scores;
  }
}
