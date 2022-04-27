import 'package:test/test.dart';
import 'package:tictactoe/src/game_internals/board_setting.dart';
import 'package:tictactoe/src/games_services/score.dart';

void main() {
  const ticTacToe = BoardSetting(3, 3, 3);
  const connectFour = BoardSetting(8, 8, 4);
  const gomokuSmall = BoardSetting(8, 8, 5);
  const gomokuLarge = BoardSetting(12, 12, 5);

  test('small scores for small victories', () {
    var a = Score(1, ticTacToe, 1, const Duration(seconds: 7));
    var b = Score(1, ticTacToe, 1, const Duration(seconds: 10));

    expect(a.score, greaterThan(b.score));
    expect(a.score, greaterThan(10));
    expect(a.score, lessThan(2000));
  });

  test("super quick tic tac toe win doesn't beat an actually challenging win",
      () {
    var a = Score(1, ticTacToe, 1, const Duration(seconds: 3));
    var b = Score(4, connectFour, 4, const Duration(seconds: 40));

    expect(a.score, lessThan(b.score));
  });

  test('medium scores for medium victories', () {
    var a = Score(4, connectFour, 4, const Duration(seconds: 30));
    var b = Score(4, connectFour, 4, const Duration(seconds: 40));

    expect(a.score, greaterThan(b.score));
    expect(a.score, greaterThan(2000));
    expect(a.score, lessThan(10000));
  });

  test('gomoku scores for gomoku victories', () {
    var a = Score(5, gomokuLarge, 5, const Duration(seconds: 30));

    expect(a.score, greaterThan(10000));
    expect(a.score, lessThan(25000));
  });

  test('big scores for big victories', () {
    var a = Score(9, gomokuLarge, 12, const Duration(minutes: 2));

    expect(a.score, greaterThan(25000));
    expect(a.score, lessThan(1000000));
  });

  test('bad performance is scored low (but non-zero)', () {
    var a = Score(1, ticTacToe, 1, const Duration(minutes: 10));
    var b = Score(1, ticTacToe, 1, const Duration(seconds: 10));

    expect(a.score, lessThan(b.score));
    expect(a.score, greaterThan(0));
  });

  test("extremely bad performance doesn't break the game", () {
    var a = Score(1, ticTacToe, 1, const Duration(days: 20000));
    var b = Score(1, ticTacToe, 1, const Duration(seconds: 10));

    expect(a.score, lessThan(b.score));
    expect(a.score, greaterThanOrEqualTo(0));
  });

  test("same time on harder levels is scored higher", () {
    var a = Score(2, connectFour, 2, const Duration(minutes: 5));
    var b = Score(3, connectFour, 3, const Duration(minutes: 5));

    expect(a.score, lessThan(b.score));
  });

  test("slightly worse time on harder levels is still scored higher", () {
    var a = Score(2, connectFour, 2, const Duration(minutes: 5));
    var b = Score(3, connectFour, 3, const Duration(minutes: 7));

    expect(a.score, lessThan(b.score));
  });

  test("much worse time on harder levels is scored lower", () {
    var a = Score(2, connectFour, 2, const Duration(minutes: 5));
    var b = Score(3, connectFour, 3, const Duration(minutes: 15));

    expect(a.score, greaterThan(b.score));
  });

  test("k has effect on scoring", () {
    var a = Score(3, connectFour, 3, const Duration(seconds: 42));
    var b = Score(3, gomokuSmall, 3, const Duration(seconds: 42));

    expect(a.score, lessThan(b.score));
  });

  test("size (m,n) has no effect on scoring", () {
    // Because larger size generally means more ways to win.
    var a = Score(3, gomokuSmall, 3, const Duration(seconds: 42));
    var b = Score(3, gomokuLarge, 3, const Duration(seconds: 42));

    expect(a.score, equals(b.score));
  });
}
