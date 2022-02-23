import 'dart:math';

import 'package:flutter_game_sample/src/ai/ai_opponent.dart';
import 'package:flutter_game_sample/src/game_internals/board_setting.dart';
import 'package:flutter_game_sample/src/game_internals/board_state.dart';
import 'package:flutter_game_sample/src/game_internals/tile.dart';

/// An AI that doesn't look ahead, and only scores tiles.
///
/// It makes moves that are similar to what a human player might make.
class HumanlikeOpponent extends AiOpponent {
  /// Scores corresponding to a given number of taken tiles.
  ///
  /// For example, if a run of `k` tiles has 3 player tiles in it,
  /// it will be scored with `400`. If it has 0 player tiles in it,
  /// it will be scored with `1`.
  List<int> get _playerScoring => const [1, 20, 90, 400, 8000, 0];

  /// Same as [_playerScoring], but this time we're scoring the AI's
  /// own tiles.
  List<int> get _aiScoring => const [2, 30, 100, 500, 10000, 0];

  /// The strength of the AI, between `0` and `1`.
  ///
  /// At `1`, the AI plays "perfectly". At `0`, it plays according to a very
  /// naive analysis.
  final double strength;

  HumanlikeOpponent(
    BoardSetting setting, {
    required this.strength,
  })  : assert(strength <= 1),
        assert(strength >= 0),
        super(setting) {
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
    final scores = <_TileScore>[];

    final latestPlayerTile = state.getLatestTileForSide(setting.playerSide);
    final latestAiTile = state.getLatestTileForSide(setting.aiOpponentSide);

    for (var x = 0; x < setting.m; x++) {
      for (var y = 0; y < setting.n; y++) {
        final tile = Tile(x, y);

        if (state.whoIsAt(tile) != Side.none) {
          continue;
        }

        final score = _TileScore(tile);

        for (final neighbor in state.getNeighborhood(tile)) {
          if (latestPlayerTile == neighbor) {
            score.humanlikePlay += 100;
          }

          if (latestAiTile == neighbor) {
            score.humanlikePlay += 50;
          }
        }

        for (final line in state.getValidLinesThrough(tile)) {
          if (line.contains(latestPlayerTile)) {
            // Humans love to play where the opponent just played.
            score.humanlikePlay += 100;
          }

          if (line.contains(latestAiTile)) {
            // Humans also love to play where they played last.
            score.humanlikePlay += 50;
          }

          var aiTiles = line
              .where((tile) => state.whoIsAt(tile) == setting.aiOpponentSide)
              .length;
          var playerTiles = line
              .where((tile) => state.whoIsAt(tile) == setting.playerSide)
              .length;

          // Humans love to play where their other marks already are.
          score.humanlikePlay += playerTiles;

          if (aiTiles > 0 && playerTiles > 0) {
            // Lost cause. Both sides have their tokens here.
            // Cannot make a line.
            continue;
          }

          if (aiTiles == 0) {
            score.bestPlay += _playerScoring[playerTiles];
          }

          if (playerTiles == 0) {
            score.bestPlay += _aiScoring[aiTiles];
          }
        }

        scores.add(score);
      }
    }

    final highestHumanlikeScore = scores.fold<int>(
        0,
        (previousValue, element) =>
            max<int>(previousValue, element.humanlikePlay));
    final lowestHumanlikeScore = scores.fold<int>(
        0,
        (previousValue, element) =>
            min<int>(previousValue, element.humanlikePlay));
    final range = highestHumanlikeScore - lowestHumanlikeScore;

    for (final score in scores) {
      double humanlikeness;
      if (range == 0) {
        humanlikeness = 0;
      } else {
        humanlikeness = (score.humanlikePlay - lowestHumanlikeScore) / range;
      }

      final naivePenalty = humanlikeness * (1 - strength);
      score.finalScore = score.bestPlay * (1 - naivePenalty);
    }

    scores.sort((a, b) => -a.finalScore!.compareTo(b.finalScore!));

    return scores.first.tile;
  }
}

class _TileScore {
  final Tile tile;

  int bestPlay = 0;

  int humanlikePlay = 0;

  double? finalScore;

  _TileScore(this.tile);
}
