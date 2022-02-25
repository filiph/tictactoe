import 'package:flutter/material.dart';
import 'package:tictactoe/src/audio/audio_system.dart';

class Settings extends ChangeNotifier {
  bool get adsRemoved => _adsRemoved;

  final bool _adsRemoved = false;

  bool get soundIsOn => _soundIsOn;

  bool _soundIsOn = true;

  void toggleSound() {
    _soundIsOn = !_soundIsOn;
    if (_soundIsOn) {
      _audioSystem?.resumeMusic();
    } else {
      _audioSystem?.stopSound();
    }
    notifyListeners();
  }

  AudioSystem? _audioSystem;

  void attachAudioSystem(AudioSystem audioSystem) {
    _audioSystem = audioSystem;
    if (soundIsOn) {
      _audioSystem!.startMusic();
    }
  }
}
