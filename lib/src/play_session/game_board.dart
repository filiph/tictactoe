import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_game_sample/src/game_internals/ai_opponent.dart';
import 'package:flutter_game_sample/src/game_internals/board_setting.dart';
import 'package:flutter_game_sample/src/game_internals/board_state.dart';
import 'package:flutter_game_sample/src/game_internals/tile.dart';
import 'package:provider/provider.dart';

class Board extends StatefulWidget {
  const Board({Key? key, required this.setting}) : super(key: key);

  final BoardSetting setting;

  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: widget.setting.m / widget.setting.n,
      child: Column(
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

  @override
  Widget build(BuildContext context) {
    final owner = context.select((BoardState state) => state.whoIsAt(tile));
    Widget representation;
    switch (owner) {
      case Owner.none:
        representation = SizedBox();
        break;
      case Owner.x:
        representation = Text('X');
        break;
      case Owner.o:
        representation = Text('O');
        break;
    }

    return InkWell(
      onTap: () async {
        final state = context.read<BoardState>();
        if (owner != Owner.none) {
          // Ignore input when the tile is already taken by someone.
          // But keep this InkWell active, so the player can more easily
          // navigate the field with a controller / keyboard.
        } else if (state.isLocked) {
          // Ignore input when the board is locked.
          // But keep the InkWell active, for the same reason as above.
        } else {
          state.playerTakeTile(tile, Owner.x);

          await Future.delayed(const Duration(milliseconds: 300));
          if (state.hasOpenTiles) {
            final ai = context.read<RandomOpponent>();
            final tile = ai.chooseNextMove(state);
            state.aiTakeTile(tile, ai.playingAs);
          }
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
