import 'package:flutter_game_sample/src/ai/ai_opponent.dart';
import 'package:flutter_game_sample/src/ai/humanlike_opponent.dart';
import 'package:flutter_game_sample/src/ai/scoring_opponent.dart';
import 'package:flutter_game_sample/src/game_internals/board_setting.dart';

final gameLevels = [
  GameLevel(
    number: 1,
    message: 'Defeat a naive AI at tic tac toe!',
    setting: BoardSetting(3, 3, 3),
    aiDifficulty: 1,
    aiOpponentBuilder: (setting) => AttackOnlyScoringOpponent(setting),
  ),
  GameLevel(
    number: 2,
    message: 'Defeat a naive AI at four-in-a-row!',
    setting: BoardSetting(5, 5, 4),
    aiDifficulty: 1,
    aiOpponentBuilder: (setting) => HumanlikeOpponent(setting, strength: 0.2),
  ),
  GameLevel(
    number: 3,
    message: 'Defeat a naive AI at four-in-a-row!',
    setting: BoardSetting(6, 6, 4),
    aiDifficulty: 1,
    aiOpponentBuilder: (setting) => HumanlikeOpponent(setting, strength: 0.2),
  ),
  GameLevel(
    number: 4,
    message: 'Defeat a naive AI at miniature gomoku!',
    setting: BoardSetting(8, 8, 5),
    aiDifficulty: 1,
    aiOpponentBuilder: (setting) => AttackOnlyScoringOpponent(setting),
  ),
  GameLevel(
    number: 5,
    message: 'Defeat an AI at miniature gomoku!',
    setting: BoardSetting(8, 8, 5),
    aiDifficulty: 2,
    aiOpponentBuilder: (setting) => HumanlikeOpponent(setting, strength: 0.1),
  ),
  GameLevel(
    number: 6,
    message: 'Defeat a stronger AI at miniature gomoku!',
    setting: BoardSetting(8, 8, 5),
    aiDifficulty: 2,
    aiOpponentBuilder: (setting) => HumanlikeOpponent(setting, strength: 0.22),
  ),
  GameLevel(
    number: 7,
    message: 'NOT IMPLEMENTED',
    setting: BoardSetting(8, 8, 5),
    aiDifficulty: 2,
    aiOpponentBuilder: (setting) => HumanlikeOpponent(setting, strength: 0.24),
  ),
  GameLevel(
    number: 8,
    message: 'NOT IMPLEMENTED',
    setting: BoardSetting(10, 10, 5),
    aiDifficulty: 2,
    aiOpponentBuilder: (setting) => HumanlikeOpponent(setting, strength: 0.26),
  ),
  GameLevel(
    number: 9,
    message: 'NOT IMPLEMENTED',
    setting: BoardSetting(10, 10, 5),
    aiDifficulty: 2,
    aiOpponentBuilder: (setting) => HumanlikeOpponent(setting, strength: 0.3),
  ),
];

class GameLevel {
  final int number;

  final String message;

  final BoardSetting setting;

  final int aiDifficulty;

  final AiOpponent Function(BoardSetting) aiOpponentBuilder;

  const GameLevel({
    required this.number,
    required this.message,
    required this.setting,
    required this.aiDifficulty,
    required this.aiOpponentBuilder,
  });
}
