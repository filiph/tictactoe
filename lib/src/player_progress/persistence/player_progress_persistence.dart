import 'package:tictactoe/src/games_services/score.dart';

abstract class PlayerProgressPersistence {
  Future<int> getHighestLevelReached();

  Future<void> saveHighestLevelReached(int level);

  Future<List<Score>> getHighestScores();

  Future<void> saveHighestScores(List<Score> scores);
}
