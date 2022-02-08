import 'package:flutter/material.dart';

class Settings extends ChangeNotifier {
  bool get adsRemoved => _adsRemoved;

  final bool _adsRemoved = false;
}
