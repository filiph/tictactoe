import 'dart:collection';

import 'package:flutter_game_sample/src/ai/ai_opponent.dart';
import 'package:flutter_game_sample/src/game_internals/board_setting.dart';
import 'package:flutter_game_sample/src/game_internals/board_state.dart';
import 'package:flutter_game_sample/src/game_internals/tile.dart';

/// An AI that doesn't look ahead, and only scores tiles.
///
/// Heavily inspired by an ancient algorithm called "Piskvorky 95"
/// by Miroslav Novak.
class ScoringOpponent extends AiOpponent {
  const ScoringOpponent(BoardSetting setting) : super(setting);

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

          if (aiTiles == 0 && playerTiles == 0) {
            // Completely blank line. Add 1 for attack and 1 for defense.
            score += 2;
            continue;
          }

          if (playerTiles > 0) {
            // Defense. Add +1 to have at least as much as blank lines.
            score += playerTiles + 1;
            if (playerTiles == setting.k - 2) {
              score += 20;
            }
            continue;
          }

          assert(aiTiles > 0);
          // Attack. Add +1 to have at least as much as blank lines.
          score += aiTiles + 1;
          if (aiTiles == setting.k - 1) {
            score += 50;
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
