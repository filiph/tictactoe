import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_game_sample/src/game_internals/board_setting.dart';
import 'package:flutter_game_sample/src/game_internals/board_state.dart';
import 'package:flutter_game_sample/src/game_internals/tile.dart';
import 'package:flutter_game_sample/src/rough/grid.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

class Board extends StatefulWidget {
  final VoidCallback? onPlayerWon;

  const Board({Key? key, required this.setting, this.onPlayerWon})
      : super(key: key);

  final BoardSetting setting;

  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: widget.setting.m / widget.setting.n,
      child: Stack(
        fit: StackFit.expand,
        children: [
          RoughGrid(widget.setting.m, widget.setting.n),
          Column(
            children: [
              for (var y = 0; y < widget.setting.n; y++)
                Expanded(
                  child: Row(
                    children: [
                      for (var x = 0; x < widget.setting.m; x++)
                        Expanded(
                          child: _BoardTile(Tile(x, y)),
                        ),
                    ],
                  ),
                )
            ],
          )
        ],
      ),
    );
  }
}

class _BoardTile extends StatelessWidget {
  _BoardTile(this.tile, {Key? key})
      : angle =
            (Random(Object.hash(tile.x, tile.y) + 1000).nextDouble() * 2 - 1) *
                0.2,
        super(key: key);

  /// The tile's position on the board.
  final Tile tile;

  /// A slight angle with which to draw the tile, so it's not that uniform.
  final double angle;

  static final Logger _log = Logger('_BoardTile');

  @override
  Widget build(BuildContext context) {
    final owner = context.select((BoardState state) => state.whoIsAt(tile));
    final isWinning = context.select(
        (BoardState state) => state.winningLine?.contains(tile) ?? false);

    Widget representation;
    final color = isWinning ? Colors.red : Colors.black;
    final style = TextStyle(color: color);
    switch (owner) {
      case Side.none:
        representation = SizedBox();
        break;
      case Side.x:
        representation = Text('X', style: style);
        break;
      case Side.o:
        representation = Text('O', style: style);
        break;
    }

    return InkResponse(
      onTap: () async {
        final state = context.read<BoardState>();
        if (!state.canTake(tile)) {
          // Ignore input when the tile is already taken by someone.
          // But keep this InkWell active, so the player can more easily
          // navigate the field with a controller / keyboard.
          _log.info('Cannot take $tile.');
        } else if (state.isLocked) {
          // Ignore input when the board is locked.
          // But keep the InkWell active, for the same reason as above.
          _log.info('Can take $tile but board is locked.');
        } else {
          state.take(tile);
        }
      },
      child: Center(
        child: Transform.rotate(
          angle: angle,
          child: DefaultTextStyle(
            style: TextStyle(
              fontFamily: 'Permanent Marker',
              color: Colors.black,
              fontSize: 50,
            ),
            child: representation,
          ),
        ),
      ),
    );
  }
}
