import 'package:flutter/material.dart';

class ResponsiveScreen extends StatelessWidget {
  /// This is the "hero" of the screen. It's more or less square, and will
  /// be placed in the visual "center" of the screen.
  final Widget squarishMainArea;

  /// The second-largest area after [squarishMainArea]. It can be narrow
  /// or wide.
  final Widget rectangularMenuArea;

  /// An area reserved for some static text close to the top of the screen.
  final Widget topMessageArea;

  const ResponsiveScreen({
    required this.squarishMainArea,
    required this.rectangularMenuArea,
    this.topMessageArea = const SizedBox.shrink(),
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // This widget wants to fill the whole screen.
        final size = constraints.biggest;
        final padding = EdgeInsets.all(size.shortestSide / 30);

        if (size.height >= size.width) {
          // "Portrait" / "mobile" mode.
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: padding,
                child: topMessageArea,
              ),
              Expanded(
                child: Padding(
                  padding: padding,
                  child: squarishMainArea,
                ),
              ),
              Padding(
                padding: padding,
                child: rectangularMenuArea,
              ),
            ],
          );
        } else {
          // "Landscape" / "tablet" mode.
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 7,
                child: Padding(
                  padding: padding,
                  child: squarishMainArea,
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Padding(
                      padding: padding,
                      child: topMessageArea,
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: padding,
                          child: rectangularMenuArea,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
