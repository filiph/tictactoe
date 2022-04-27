import 'package:tictactoe/src/ai/ai_opponent.dart';
import 'package:tictactoe/src/ai/humanlike_opponent.dart';
import 'package:tictactoe/src/ai/random_opponent.dart';
import 'package:tictactoe/src/ai/scoring_opponent.dart';
import 'package:tictactoe/src/game_internals/board_setting.dart';

final gameLevels = [
  GameLevel(
    number: 1,
    setting: const BoardSetting(3, 3, 3),
    difficulty: 1,
    aiOpponentBuilder: (setting) => RandomOpponent(
      setting,
      name: 'Blobfish',
    ),
    achievementIdIOS: 'first_win',
    achievementIdAndroid: 'CgkIgZ29mawJEAIQAg',
  ),
  GameLevel(
    number: 2,
    setting: const BoardSetting(5, 5, 4),
    difficulty: 2,
    aiOpponentBuilder: (setting) => HumanlikeOpponent(
      setting,
      name: 'Chicken',
      humanlikePlayCount: 50,
      bestPlayCount: 5,
      // Heavily defense-focused.
      playerScoring: const [30, 100, 500, 10000, 100000, 0],
      aiScoring: const [1, 1, 10, 90, 8000, 0],
    ),
  ),
  GameLevel(
    number: 3,
    setting: const BoardSetting(6, 6, 4),
    difficulty: 3,
    aiOpponentBuilder: (setting) => HumanlikeOpponent(
      setting,
      name: 'Sparklemuffin',
      humanlikePlayCount: 5,
      bestPlayCount: 3,
    ),
  ),
  GameLevel(
    number: 4,
    setting: const BoardSetting(8, 8, 5),
    difficulty: 4,
    aiOpponentBuilder: (setting) => AttackOnlyScoringOpponent(
      setting,
      name: 'Puffbird',
    ),
  ),
  GameLevel(
    number: 5,
    setting: const BoardSetting(9, 9, 5, aiStarts: true),
    difficulty: 5,
    aiOpponentBuilder: (setting) => HumanlikeOpponent(
      setting,
      name: 'Gecko',
      humanlikePlayCount: 3,
      bestPlayCount: 12,
      stubbornness: 0.10,
    ),
    achievementIdIOS: 'half_way',
    achievementIdAndroid: 'CgkIgZ29mawJEAIQAw',
  ),
  GameLevel(
    number: 6,
    setting: const BoardSetting(9, 9, 5),
    difficulty: 6,
    aiOpponentBuilder: (setting) => HumanlikeOpponent(
      setting,
      name: 'Wobbegong',
      humanlikePlayCount: 2,
      bestPlayCount: 10,
      stubbornness: 0.1,
    ),
  ),
  GameLevel(
    number: 7,
    setting: const BoardSetting(10, 10, 5),
    difficulty: 7,
    aiOpponentBuilder: (setting) => HumanlikeOpponent(
      setting,
      name: 'Boops',
      humanlikePlayCount: 3,
      bestPlayCount: 5,
    ),
  ),
  GameLevel(
    number: 8,
    setting: const BoardSetting(10, 10, 5),
    difficulty: 8,
    aiOpponentBuilder: (setting) => HumanlikeOpponent(
      setting,
      name: 'Fossa',
      humanlikePlayCount: 4,
      bestPlayCount: 5,
    ),
  ),
  GameLevel(
    number: 9,
    setting: const BoardSetting(11, 11, 5),
    difficulty: 20,
    aiOpponentBuilder: (setting) => HumanlikeOpponent(
      setting,
      name: 'Tiger',
      humanlikePlayCount: 10,
      bestPlayCount: 2,
    ),
    achievementIdIOS: 'finished',
    achievementIdAndroid: 'CgkIgZ29mawJEAIQBA',
  ),
];

class GameLevel {
  final int number;

  final BoardSetting setting;

  final int difficulty;

  final AiOpponent Function(BoardSetting) aiOpponentBuilder;

  /// The achievement to unlock when the level is finished, if any.
  final String? achievementIdIOS;

  final String? achievementIdAndroid;

  bool get awardsAchievement => achievementIdAndroid != null;

  const GameLevel({
    required this.number,
    required this.setting,
    required this.difficulty,
    required this.aiOpponentBuilder,
    this.achievementIdIOS,
    this.achievementIdAndroid,
  }) : assert(
            (achievementIdAndroid != null && achievementIdIOS != null) ||
                (achievementIdAndroid == null && achievementIdIOS == null),
            'Either both iOS and Android achievement ID must be provided, '
            'or none');
}
