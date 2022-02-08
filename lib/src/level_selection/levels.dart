import 'package:flutter_game_sample/src/game_internals/ai_opponent.dart';
import 'package:flutter_game_sample/src/game_internals/board_setting.dart';

final gameLevels = [
  Level(
    number: 1,
    message: 'Defeat a random generator at tic tac toe!',
    setting: BoardSetting(3, 3, 3),
    aiOpponentBuilder: (setting) => RandomOpponent(setting),
  ),
  Level(
    number: 2,
    message: 'Defeat a random generator at connect-four!',
    setting: BoardSetting(5, 5, 4),
    aiOpponentBuilder: (setting) => RandomOpponent(setting),
  ),
  Level(
    number: 3,
    message: 'Defeat a random generator at miniature gomoku!',
    setting: BoardSetting(6, 6, 5),
    aiOpponentBuilder: (setting) => RandomOpponent(setting),
  ),
  Level(
    number: 4,
    message: 'NOT IMPLEMENTED',
    setting: BoardSetting(6, 6, 5),
    aiOpponentBuilder: (setting) => RandomOpponent(setting),
  ),
  Level(
    number: 5,
    message: 'NOT IMPLEMENTED',
    setting: BoardSetting(6, 6, 5),
    aiOpponentBuilder: (setting) => RandomOpponent(setting),
  ),
  Level(
    number: 6,
    message: 'NOT IMPLEMENTED',
    setting: BoardSetting(6, 6, 5),
    aiOpponentBuilder: (setting) => RandomOpponent(setting),
  ),
  Level(
    number: 7,
    message: 'NOT IMPLEMENTED',
    setting: BoardSetting(6, 6, 5),
    aiOpponentBuilder: (setting) => RandomOpponent(setting),
  ),
  Level(
    number: 8,
    message: 'NOT IMPLEMENTED',
    setting: BoardSetting(6, 6, 5),
    aiOpponentBuilder: (setting) => RandomOpponent(setting),
  ),
  Level(
    number: 9,
    message: 'NOT IMPLEMENTED',
    setting: BoardSetting(6, 6, 5),
    aiOpponentBuilder: (setting) => RandomOpponent(setting),
  ),
];

class Level {
  final int number;

  final String message;

  final BoardSetting setting;

  final AiOpponent Function(BoardSetting) aiOpponentBuilder;

  const Level({
    required this.number,
    required this.message,
    required this.setting,
    required this.aiOpponentBuilder,
  });
}
