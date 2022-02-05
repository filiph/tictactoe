import 'dart:math';

import 'package:flutter_game_sample/src/game_internals/board_setting.dart';
import 'package:flutter_game_sample/src/game_internals/board_state.dart';
import 'package:flutter_game_sample/src/game_internals/tile.dart';

abstract class AiOpponent {
  final BoardSetting setting;

  final Owner playingAs = Owner.o;

  const AiOpponent(this.setting);

  /// Returns the move that the AI wants to play.
  ///
  /// Calling this function when [state] has no open tiles will throw.
  Tile chooseNextMove(BoardState state);
}

class RandomOpponent extends AiOpponent {
  RandomOpponent(BoardSetting setting) : super(setting);

  final Random _random = Random();

  @override
  Tile chooseNextMove(BoardState state) {
    final options = <Tile>[];
    for (var x = 0; x < setting.m; x++) {
      for (var y = 0; y < setting.n; y++) {
        final tile = Tile(x, y);
        if (state.whoIsAt(tile) == Owner.none) {
          options.add(tile);
        }
      }
    }

    return options[_random.nextInt(options.length)];
  }
}
