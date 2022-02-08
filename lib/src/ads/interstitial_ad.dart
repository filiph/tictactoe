import 'package:flutter/material.dart';

class InterstitialAd extends StatefulWidget {
  final VoidCallback onClose;

  const InterstitialAd({Key? key, required this.onClose}) : super(key: key);

  @override
  State<InterstitialAd> createState() => _InterstitialAdState();
}

class _InterstitialAdState extends State<InterstitialAd>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AspectRatio(
            aspectRatio: 3 / 4,
            child: Container(
              color: Colors.grey,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 40),
                    Text('Interstitial ad'),
                  ],
                ),
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) => LinearProgressIndicator(
              value: _controller.value,
            ),
          ),
          SizedBox(height: 50),
          TextButton(
            onPressed: widget.onClose,
            child: Text('Skip'),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  static const _adDuration = Duration(milliseconds: 3000);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _adDuration,
    )
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onClose();
        }
      })
      ..forward();
  }
}
