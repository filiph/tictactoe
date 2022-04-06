import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:tictactoe/src/audio/audio_controller.dart';
import 'package:tictactoe/src/settings/persistence/settings_persistence.dart';

class SettingsController extends ChangeNotifier {
  bool _muted = false;

  final SettingsPersistence _persistence;

  AudioController? _audioController;

  bool _soundsOn = false;

  bool _musicOn = false;

  SettingsController({required SettingsPersistence persistence})
      : _persistence = persistence;

  bool get musicOn => _musicOn;

  String get playerName => _playerName;

  String _playerName = 'Player';

  /// Whether or not the sound is on at all. This overrides both music
  /// and sound.
  bool get muted => _muted;

  bool get soundsOn => _soundsOn;

  void attachAudioController(AudioController audioController) {
    if (audioController == _audioController) {
      return;
    }
    _audioController = audioController;
    if (!_muted && _musicOn) {
      _audioController!.startMusic();
    }
  }

  Future<void> loadStateFromPersistence() async {
    await Future.wait([
      /// The sound starts on (`true`) on every device target except for the web.
      /// On the web, sound can only start after user interaction.
      _persistence
          .getMuted(defaultValue: kIsWeb)
          .then((value) => _muted = value),
      _persistence.getSoundsOn().then((value) => _soundsOn = value),
      _persistence.getMusicOn().then((value) => _musicOn = value),
      _persistence.getPlayerName().then((value) => _playerName = value),
    ]);
    if (_muted) {
      _audioController?.stopAllSound();
    } else {
      if (_musicOn) {
        _audioController?.resumeMusic();
      }
    }
    notifyListeners();
  }

  void toggleMusicOn() {
    _musicOn = !_musicOn;
    if (_musicOn) {
      if (!_muted) {
        _audioController?.resumeMusic();
      }
    } else {
      _audioController?.stopMusic();
    }
    notifyListeners();
    _persistence.saveMusicOn(_musicOn);
  }

  void setPlayerName(String name) {
    _playerName = name;
    notifyListeners();
    _persistence.savePlayerName(_playerName);
  }

  void toggleMuted() {
    _muted = !_muted;
    if (_muted) {
      _audioController?.stopAllSound();
    } else {
      if (_musicOn) {
        _audioController?.resumeMusic();
      }
    }
    notifyListeners();
    _persistence.saveMute(_muted);
  }

  void toggleSoundsOn() {
    _soundsOn = !_soundsOn;
    notifyListeners();
    _persistence.saveSoundsOn(_soundsOn);
  }

  ValueNotifier<AppLifecycleState>? _lifecycleNotifier;

  void attachLifecycleNotifier(
      ValueNotifier<AppLifecycleState> lifecycleNotifier) {
    if (_lifecycleNotifier != null) {
      _lifecycleNotifier!.removeListener(_handleAppLifecycle);
    }
    _lifecycleNotifier = lifecycleNotifier;
    _lifecycleNotifier?.addListener(_handleAppLifecycle);
  }

  @override
  void dispose() {
    _lifecycleNotifier?.removeListener(_handleAppLifecycle);
    super.dispose();
  }

  void _handleAppLifecycle() {
    switch (_lifecycleNotifier!.value) {
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        _audioController?.stopAllSound();
        break;
      case AppLifecycleState.resumed:
        if (!_muted && _musicOn) {
          _audioController?.resumeMusic();
        }
        break;
      case AppLifecycleState.inactive:
        // No need to react to this state change.
        break;
    }
  }
}
