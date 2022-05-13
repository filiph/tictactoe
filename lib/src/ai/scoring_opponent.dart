import 'dart:collection';

import 'package:tictactoe/src/ai/ai_opponent.dart';
import 'package:tictactoe/src/game_internals/board_setting.dart';
import 'package:tictactoe/src/game_internals/board_state.dart';
import 'package:tictactoe/src/game_internals/tile.dart';

/// An AI that doesn't look ahead, and only scores tiles.
///
/// Heavily inspired by an ancient algorithm called "Piskvorky 95"
/// by Miroslav Novak.
class ScoringOpponent extends AiOpponent {
  /// Scores corresponding to a given number of taken tiles.
  ///
  /// For example, if a run of `k` tiles has 3 player tiles in it,
  /// it will be scored with `400`. If it has 0 player tiles in it,
  /// it will be scored with `1`.
  List<int> get _playerScoring => const [1, 20, 90, 400, 8000, 0];

  /// Same as [_playerScoring], but this time we're scoring the AI's
  /// own tiles.
  List<int> get _aiScoring => const [2, 30, 100, 500, 10000, 0];

  @override
  final String name;

  ScoringOpponent(BoardSetting setting, {required this.name}) : super(setting) {
    assert(
        setting.k <= _playerScoring.length + 1,
        'Scoring opponent does not support games '
        'with more than 5 in a row');
    assert(
        setting.k <= _aiScoring.length + 1,
        'Scoring opponent does not support games '
        'with more than 5 in a row');
  }

  @override
  Tile chooseNextMove(BoardState state) {
    final options = <Tile, int>{};
    for (var x = 0; x < setting.m; x++) {
      for (var y = 0; y < setting.n; y++) {
        final tile = Tile(x, y);

        if (state.whoIsAt(tile) != Side.none) {
          continue;
        }

        int score = 0;

        for (final line in state.getValidLinesThrough(tile)) {
          var aiTiles = line
              .where((tile) => state.whoIsAt(tile) == setting.aiOpponentSide)
              .length;
          var playerTiles = line
              .where((tile) => state.whoIsAt(tile) == setting.playerSide)
              .length;
          if (aiTiles > 0 && playerTiles > 0) {
            // Lost cause. Both sides have their tokens here.
            // Cannot make a line.
            continue;
          }

          if (aiTiles == 0) {
            score += _playerScoring[playerTiles];
          }

          if (playerTiles == 0) {
            score += _aiScoring[aiTiles];
          }
        }

        options[tile] = score;
      }
    }

    final sorted = SplayTreeMap<Tile, int>.from(
        options, (a, b) => -options[a]!.compareTo(options[b]!));

    return sorted.firstKey()!;
  }
}

/// A scoring opponent that just cares about attacking.
class AttackOnlyScoringOpponent extends ScoringOpponent {
  AttackOnlyScoringOpponent(super.setting, {required super.name});

  @override
  List<int> get _playerScoring => const [1, 1, 20, 90, 8000, 0];

  @override
  List<int> get _aiScoring => const [2, 30, 100, 500, 10000, 0];
}
