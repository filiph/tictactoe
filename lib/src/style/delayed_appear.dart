import 'package:flutter/widgets.dart';

/// Shows [child], but only after [ms] milliseconds of delay.
///
/// If [delayStateCreation] is `true`, this widget will only add [child]
/// to the widget tree _after_ the delay. That way,
/// any animations of the child only start after the delay.
///
/// Useful for orchestrating an appearing effect, where different parts
/// of the UI appear at different times.
class DelayedAppear extends StatefulWidget {
  final Widget child;

  final Duration delay;

  final bool delayStateCreation;

  final VoidCallback? onDelayFinished;

  DelayedAppear({
    required this.child,
    required int ms,
    this.delayStateCreation = false,
    this.onDelayFinished,
    super.key,
  }) : delay = Duration(milliseconds: ms);

  @override
  State<DelayedAppear> createState() => _DelayedAppearState();
}

class _DelayedAppearState extends State<DelayedAppear>
    with TickerProviderStateMixin {
  static const fadeDuration = Duration(milliseconds: 300);

  late final AnimationController _delayController;

  late final AnimationController _fadeController;

  bool _delayFinished = false;

  @override
  Widget build(BuildContext context) {
    if (!_delayFinished && widget.delayStateCreation) {
      return const SizedBox.shrink();
    }
    return FadeTransition(
      opacity: _fadeController,
      child: widget.child,
    );
  }

  @override
  void initState() {
    super.initState();
    _delayController = AnimationController(
      duration: widget.delay,
      vsync: this,
    );

    _delayController.animateTo(1.0).then((_) {
      if (!mounted) return;
      setState(() {
        _delayFinished = true;
        _fadeController.forward();
        widget.onDelayFinished?.call();
      });
    });

    _fadeController = AnimationController(
      duration: fadeDuration,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _delayController.dispose();
    _fadeController.dispose();
    super.dispose();
  }
}

class ScreenDelays {
  static const int _cadence = 300;

  static const int first = 400;
  static int second = first + _cadence;
  static int third = second + _cadence;
  static int fourth = third + _cadence;
  static int fifth = fourth + _cadence;
}
