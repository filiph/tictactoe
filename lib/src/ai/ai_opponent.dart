import 'package:flutter_game_sample/src/game_internals/board_setting.dart';
import 'package:flutter_game_sample/src/game_internals/board_state.dart';
import 'package:flutter_game_sample/src/game_internals/tile.dart';

abstract class AiOpponent {
  final BoardSetting setting;

  const AiOpponent(this.setting);

  /// Returns the move that the AI wants to play.
  ///
  /// Calling this function when [state] has no open tiles will throw.
  Tile chooseNextMove(BoardState state);
}
