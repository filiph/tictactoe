import 'package:flutter_game_sample/src/ai/ai_opponent.dart';
import 'package:flutter_game_sample/src/ai/random_opponent.dart';
import 'package:flutter_game_sample/src/ai/scoring_opponent.dart';
import 'package:flutter_game_sample/src/game_internals/board_setting.dart';

final gameLevels = [
  Level(
    number: 1,
    message: 'Defeat a naive AI at tic tac toe!',
    setting: BoardSetting(3, 3, 3),
    aiDifficulty: 1,
    aiOpponentBuilder: (setting) => AttackOnlyScoringOpponent(setting),
  ),
  Level(
    number: 2,
    message: 'Defeat a naive AI at four-in-a-row!',
    setting: BoardSetting(5, 5, 4),
    aiDifficulty: 1,
    aiOpponentBuilder: (setting) => AttackOnlyScoringOpponent(setting),
  ),
  Level(
    number: 3,
    message: 'Defeat a solid AI at four-in-a-row!',
    setting: BoardSetting(5, 5, 4),
    aiDifficulty: 2,
    aiOpponentBuilder: (setting) => ScoringOpponent(setting),
  ),
  Level(
    number: 4,
    message: 'Defeat a random generator at miniature gomoku!',
    setting: BoardSetting(8, 8, 5),
    aiDifficulty: 1,
    aiOpponentBuilder: (setting) => RandomOpponent(setting),
  ),
  Level(
    number: 5,
    message: 'Defeat an AI at miniature gomoku!',
    setting: BoardSetting(8, 8, 5),
    aiDifficulty: 2,
    aiOpponentBuilder: (setting) => ScoringOpponent(setting),
  ),
  Level(
    number: 6,
    message: 'NOT IMPLEMENTED',
    setting: BoardSetting(6, 6, 5),
    aiDifficulty: 2,
    aiOpponentBuilder: (setting) => ScoringOpponent(setting),
  ),
  Level(
    number: 7,
    message: 'NOT IMPLEMENTED',
    setting: BoardSetting(6, 6, 5),
    aiDifficulty: 2,
    aiOpponentBuilder: (setting) => ScoringOpponent(setting),
  ),
  Level(
    number: 8,
    message: 'NOT IMPLEMENTED',
    setting: BoardSetting(6, 6, 5),
    aiDifficulty: 2,
    aiOpponentBuilder: (setting) => ScoringOpponent(setting),
  ),
  Level(
    number: 9,
    message: 'NOT IMPLEMENTED',
    setting: BoardSetting(6, 6, 5),
    aiDifficulty: 2,
    aiOpponentBuilder: (setting) => ScoringOpponent(setting),
  ),
];

class Level {
  final int number;

  final String message;

  final BoardSetting setting;

  final int aiDifficulty;

  final AiOpponent Function(BoardSetting) aiOpponentBuilder;

  const Level({
    required this.number,
    required this.message,
    required this.setting,
    required this.aiDifficulty,
    required this.aiOpponentBuilder,
  });
}
