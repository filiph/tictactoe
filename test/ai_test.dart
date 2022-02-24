import 'package:flutter_game_sample/src/ai/ai_opponent.dart';
import 'package:flutter_game_sample/src/ai/humanlike_opponent.dart';
import 'package:flutter_game_sample/src/ai/scoring_opponent.dart';
import 'package:flutter_game_sample/src/game_internals/board_setting.dart';
import 'package:flutter_game_sample/src/game_internals/board_state.dart';
import 'package:flutter_game_sample/src/game_internals/tile.dart';
import 'package:test/test.dart';

void main() {
  group('AttackOnlyScoringOpponent', () {
    late BoardSetting setting;
    late AiOpponent opponent;

    setUp(() {
      setting = BoardSetting(5, 5, 4);
      opponent = AttackOnlyScoringOpponent(setting);
    });

    test('tries to stop a 4 too late', () {
      final state = makeBoard(
        setting,
        opponent,
        '     '
        '   X '
        '  XOO'
        ' X   '
        '     ',
      );

      final tile = opponent.chooseNextMove(state);
      expect(tile, anyOf(Tile(0, 4), Tile(4, 0)));
    });
  });

  group('HumanlikeOpponent', () {
    late BoardSetting setting;
    late AiOpponent opponent;

    setUp(() {
      setting = BoardSetting(5, 5, 4);
      opponent = HumanlikeOpponent(
        setting,
        humanlikePlayCount: 1,
        bestPlayCount: 5,
      );
    });

    test('tries to stop a 4 close to where it should', () {
      final state = makeBoard(
        setting,
        opponent,
        '     '
        '   X '
        '  xoO'
        ' x   '
        '     ',
      );

      final tile = opponent.chooseNextMove(state);
      expect(tile, Tile(0, 4));

      final state2 = makeBoard(
        setting,
        opponent,
        '     '
        '   x '
        '  xoO'
        ' X   '
        '     ',
      );

      final tile2 = opponent.chooseNextMove(state2);
      expect(tile2, Tile(4, 0));
    });
  });
}

BoardState makeBoard(
    BoardSetting setting, AiOpponent opponent, String stringRepresentation) {
  assert(stringRepresentation.length == setting.m * setting.n);
  final takenByX = <int>{};
  final takenByO = <int>{};
  Tile? latestX;
  Tile? latestO;

  for (var i = 0; i < setting.m * setting.n; i++) {
    if (stringRepresentation[i].toLowerCase() == 'x') {
      takenByX.add(i);
    } else if (stringRepresentation[i].toLowerCase() == 'o') {
      takenByO.add(i);
    } else {
      assert(stringRepresentation[i] == ' ');
    }
    if (stringRepresentation[i] == 'X') {
      latestX = Tile.fromPointer(i, setting);
    } else if (stringRepresentation[i] == 'O') {
      latestO = Tile.fromPointer(i, setting);
    }
  }

  return BoardState.withExistingState(
    setting: setting,
    aiOpponent: opponent,
    takenByX: takenByX,
    takenByO: takenByO,
    latestX: latestX,
    latestO: latestO,
  );
}
