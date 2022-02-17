import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_game_sample/src/game_internals/board_state.dart';
import 'package:flutter_game_sample/src/game_internals/tile.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

class BoardTile extends StatefulWidget {
  const BoardTile(this.tile, {Key? key}) : super(key: key);

  /// The tile's position on the board.
  final Tile tile;

  static final Logger _log = Logger('_BoardTile');

  @override
  State<BoardTile> createState() => _BoardTileState();
}

class _BoardTileState extends State<BoardTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  Side? _previousOwner;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final owner = context.read<BoardState>().whoIsAt(widget.tile);

    // Show the tile immediately if we already start with something
    // on it.
    if (_previousOwner == null && owner != Side.none) {
      _controller.value = 1;
    }

    // Reset the animation if something made the tile disappear.
    // (Probably the "Reset" button.)
    if (_previousOwner != Side.none && owner == Side.none) {
      _controller.value = 0;
    }

    // Play animation if the player or the AI marked this tile.
    if (_previousOwner == Side.none && owner != Side.none) {
      _controller.forward();
    }

    _previousOwner = owner;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final owner =
        context.select((BoardState state) => state.whoIsAt(widget.tile));
    final isWinning = context.select((BoardState state) =>
        state.winningLine?.contains(widget.tile) ?? false);

    Widget representation;
    final color = isWinning ? Colors.red : Colors.black87;
    final progress =
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    switch (owner) {
      case Side.none:
        representation = SizedBox.expand();
        break;
      case Side.x:
        representation = _SketchedX(
          color: color,
          progress: progress,
          variantSeed: widget.tile.hashCode,
        );
        break;
      case Side.o:
        representation = _SketchedO(
          color: color,
          progress: progress,
          variantSeed: widget.tile.hashCode,
        );
        break;
    }

    return InkResponse(
      onTap: () async {
        final state = context.read<BoardState>();
        if (!state.canTake(widget.tile)) {
          // Ignore input when the tile is already taken by someone.
          // But keep this InkWell active, so the player can more easily
          // navigate the field with a controller / keyboard.
          BoardTile._log.info('Cannot take ${widget.tile}.');
        } else if (state.isLocked) {
          // Ignore input when the board is locked.
          // But keep the InkWell active, for the same reason as above.
          BoardTile._log.info('Can take ${widget.tile} but board is locked.');
        } else {
          state.take(widget.tile);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: representation,
      ),
    );
  }
}

class _SketchedX extends StatelessWidget {
  final Animation<double> progress;

  final Color color;

  /// An integer that will be used to select a variant of the mark.
  /// Can be any integer.
  final int variantSeed;

  const _SketchedX({
    Key? key,
    required this.color,
    required this.progress,
    required this.variantSeed,
  }) : super(key: key);

  static const _startImageAssets = [
    'assets/images/cross-start-1.png',
    'assets/images/cross-start-2.png',
    'assets/images/cross-start-3.png',
    'assets/images/cross-start-4.png',
    'assets/images/cross-start-5.png',
  ];

  static const _endImageAssets = [
    'assets/images/cross-end-1.png',
    'assets/images/cross-end-2.png',
    'assets/images/cross-end-3.png',
    'assets/images/cross-end-4.png',
    'assets/images/cross-end-5.png',
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width =
          constraints.maxWidth * MediaQuery.of(context).devicePixelRatio;
      final resizeCrossStart = ResizeImage(
        AssetImage(_startImageAssets[variantSeed % _startImageAssets.length]),
        width: width.ceil(),
      );
      final crossStart = Image(
        image: resizeCrossStart,
        color: color,
      );
      final resizeCrossEnd = ResizeImage(
        AssetImage(_endImageAssets[
            Object.hash(42, variantSeed) % _endImageAssets.length]),
        width: width.ceil(),
      );
      final crossEnd = Image(
        image: resizeCrossEnd,
        color: color,
      );

      return Stack(
        children: [
          AnimatedBuilder(
            animation: progress,
            builder: (context, child) {
              return ShaderMask(
                blendMode: BlendMode.dstIn,
                shaderCallback: (bounds) {
                  return LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.black,
                      Colors.white.withOpacity(0),
                    ],
                    stops: [
                      progress.value * 2,
                      progress.value * 2 + 0.05,
                    ],
                  ).createShader(bounds);
                },
                child: child,
              );
            },
            child: crossStart,
          ),
          AnimatedBuilder(
            animation: progress,
            builder: (context, child) {
              return ShaderMask(
                blendMode: BlendMode.dstIn,
                shaderCallback: (bounds) {
                  return LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Colors.black,
                      Colors.white.withOpacity(0),
                    ],
                    stops: [
                      -1 + progress.value * 2,
                      -1 + progress.value * 2 + 0.05,
                    ],
                  ).createShader(bounds);
                },
                child: child,
              );
            },
            child: crossEnd,
          ),
        ],
      );
    });
  }
}

class _SketchedO extends StatelessWidget {
  final Animation<double> progress;

  final Color color;

  /// An integer that will be used to select a variant of the mark.
  /// Can be any integer.
  final int variantSeed;

  const _SketchedO({
    Key? key,
    required this.color,
    required this.progress,
    required this.variantSeed,
  }) : super(key: key);

  static const _imageAssets = [
    'assets/images/circle1.png',
    'assets/images/circle2.png',
    'assets/images/circle3.png',
    'assets/images/circle4.png',
    'assets/images/circle5.png',
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width =
            constraints.maxWidth * MediaQuery.of(context).devicePixelRatio;
        final resizeImage = ResizeImage(
          AssetImage(_imageAssets[variantSeed % _imageAssets.length]),
          width: width.ceil(),
        );
        final circle = Image(
          image: resizeImage,
          color: color,
        );

        return AnimatedBuilder(
          animation: progress,
          builder: (context, child) {
            return ShaderMask(
              blendMode: BlendMode.dstIn,
              shaderCallback: (bounds) {
                return SweepGradient(
                  transform: GradientRotation(-110 / 180 * math.pi),
                  colors: [
                    Colors.black,
                    Colors.white.withOpacity(0),
                  ],
                  stops: [
                    progress.value,
                    progress.value + 0.05,
                  ],
                ).createShader(bounds);
              },
              child: child,
            );
          },
          child: circle,
        );
      },
    );
  }
}
