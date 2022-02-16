import 'package:flutter/material.dart';

class RoughButton extends StatelessWidget {
  final Widget child;

  final VoidCallback? onTap;

  const RoughButton({
    Key? key,
    required this.child,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 34,
          vertical: 18,
        ),
        child: DefaultTextStyle(
          style: TextStyle(
            fontFamily: 'Permanent Marker',
            fontSize: 26,
            color: onTap != null ? Colors.red : Colors.black,
            decoration: onTap != null ? TextDecoration.underline : null,
          ),
          child: child,
        ),
      ),
    );
  }
}
