import 'package:tictactoe/src/achievements/score.dart';

abstract class PlayerProgressPersistentStore {
  Future<int> getHighestLevelReached();

  Future<void> saveHighestLevelReached(int level);

  Future<List<Score>> getHighestScores();

  Future<void> saveHighestScores(List<Score> scores);
}
