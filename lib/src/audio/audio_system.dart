import 'dart:math';

import 'package:audioplayers/audioplayers.dart' hide Logger;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

class AudioSystem extends ChangeNotifier {
  static final _log = Logger('AudioSystem');

  bool _isOn = false;

  final AudioCache _musicCache;

  final AudioCache _sfxCache;

  final AudioPlayer musicPlayer;

  final AudioPlayer sfxPlayer;

  /// This class takes ownership of the [musicPlayer] and the [sfxPlayer]
  /// and will dispose of them when disposed.
  AudioSystem({required this.musicPlayer, required this.sfxPlayer})
      : _musicCache = AudioCache(
          fixedPlayer: musicPlayer,
          prefix: 'assets/music/',
        ),
        _sfxCache = AudioCache(
          prefix: 'assets/sfx/',
        );

  bool get isOn => _isOn;

  set isOn(bool value) {
    if (value == _isOn) return;
    _isOn = value;
    notifyListeners();
  }

  @override
  void dispose() {
    musicPlayer.dispose();
    sfxPlayer.dispose();
    super.dispose();
  }

  void resumeAfterAppPaused() {
    if (_isOn) {
      resumeMusic();
    }
  }

  void startMusic() {
    _log.info('starting music');
    _musicCache.loop('Mr-Smith-Sonorus.mp3');
  }

  void resumeMusic() {
    musicPlayer.resume();
  }

  void stopForAppPaused() {
    mute();
  }

  void mute() {
    musicPlayer.pause();
    sfxPlayer.stop();
  }

  final Random _random = Random();

  void playSfx(SfxType type) {
    _log.info('Playing sound: $type');
    final options = _soundTypeToFilename(type);
    final filename = options[_random.nextInt(options.length)];
    _log.info('- Chosen filename: $filename');
    _sfxCache.play(filename, mode: PlayerMode.LOW_LATENCY);
  }

  void initialize() async {
    _log.info('Preloading sound effects');
    await _sfxCache
        .loadAll(SfxType.values.expand(_soundTypeToFilename).toList());
  }
}

class AudioSystemWrapper extends StatefulWidget {
  final Widget child;

  const AudioSystemWrapper({required this.child, Key? key}) : super(key: key);

  @override
  _AudioSystemWrapperState createState() => _AudioSystemWrapperState();
}

class _AudioSystemWrapperState extends State<AudioSystemWrapper>
    with WidgetsBindingObserver {
  static final _log = Logger('AudioSystemWrapper');

  late AudioSystem _audioSystem;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AudioSystem>.value(
      value: _audioSystem,
      child: widget.child,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _log.info('didChangeAppLifecycleState: $state');
    switch (state) {
      case AppLifecycleState.paused:
        _audioSystem.stopForAppPaused();
        break;
      case AppLifecycleState.resumed:
        _audioSystem.resumeAfterAppPaused();
        break;
      case AppLifecycleState.detached:
        _audioSystem.stopForAppPaused();
        break;
      case AppLifecycleState.inactive:
        // No need to react to this state change.
        break;
    }
  }

  @override
  void dispose() {
    _audioSystem.dispose();
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _audioSystem = AudioSystem(
      musicPlayer: AudioPlayer(playerId: 'musicPlayer'),
      sfxPlayer: AudioPlayer(
        mode: kIsWeb ? PlayerMode.MEDIA_PLAYER : PlayerMode.LOW_LATENCY,
        playerId: 'soundsPlayer',
      ),
    );
    _log.info('AudioSystem created');

    _audioSystem.initialize();

    WidgetsBinding.instance!.addObserver(this);
    _log.info('Subscribed to app lifecycle updates');
  }
}

enum SfxType {
  drawX,
  drawO,
  buttonTap,
  congrats,
}

List<String> _soundTypeToFilename(SfxType type) {
  switch (type) {
    case SfxType.drawX:
      return [
        'hash1.mp3',
        'hash2.mp3',
        'hash3.mp3',
      ];
    case SfxType.drawO:
      return [
        'wssh1.mp3',
        'wssh2.mp3',
        'dsht1.mp3',
        'ws1.mp3',
        'spsh1.mp3',
        'hh1.mp3',
        'hh2.mp3',
        'kss1.mp3',
      ];
    case SfxType.buttonTap:
      return [
        'k1.mp3',
        'k2.mp3',
        'p1.mp3',
        'p2.mp3',
      ];
    case SfxType.congrats:
      return [
        'yay1.mp3',
        'wehee1.mp3',
        'oo1.mp3',
        'ehehee1.mp3',
      ];
  }
}
