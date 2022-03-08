import 'package:flutter/foundation.dart';
import 'package:tictactoe/src/audio/audio_system.dart';

class Settings extends ChangeNotifier {
  /// Whether or not the sound is on at all. This overrides both music
  /// and sound.
  bool get soundIsOn => _soundIsOn;

  /// The sound starts on (`true`) on every device target except for the web.
  /// On the web, sound can only start after user interaction.
  bool _soundIsOn = !kIsWeb;

  void toggleSound() {
    _soundIsOn = !_soundIsOn;
    if (_soundIsOn) {
      _audioSystem?.resumeMusic();
    } else {
      _audioSystem?.mute();
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
