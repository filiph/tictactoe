import 'package:test/test.dart';
import 'package:tictactoe/src/ai/ai_opponent.dart';
import 'package:tictactoe/src/ai/humanlike_opponent.dart';
import 'package:tictactoe/src/ai/scoring_opponent.dart';
import 'package:tictactoe/src/game_internals/board_setting.dart';
import 'package:tictactoe/src/game_internals/board_state.dart';
import 'package:tictactoe/src/game_internals/tile.dart';

void main() {
  group('AttackOnlyScoringOpponent', () {
    late BoardSetting setting;
    late AiOpponent opponent;

    setUp(() {
      setting = const BoardSetting(5, 5, 4);
      opponent = AttackOnlyScoringOpponent(setting, name: 'Test');
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
      expect(tile, anyOf(const Tile(0, 4), const Tile(4, 0)));
    });
  });

  group('HumanlikeOpponent', () {
    late BoardSetting setting;
    late AiOpponent opponent;

    setUp(() {
      setting = const BoardSetting(5, 5, 4);
      opponent = HumanlikeOpponent(
        setting,
        name: 'Test',
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
      expect(tile, const Tile(0, 4));

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
      expect(tile2, const Tile(4, 0));
    }, skip: 'fiddly, needs work');
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
