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
          fixedPlayer: musicPlayer,
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
    resumeMusic();
  }

  void startMusic() {
    _log.info('starting music');
    _musicCache.loop('Mr-Smith-Sonorus.mp3');
  }

  void resumeMusic() {
    musicPlayer.resume();
  }

  void stopForAppPaused() {
    stopSound();
  }

  void stopSound() {
    musicPlayer.pause();
    sfxPlayer.stop();
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
        // TODO: Handle this case.
        break;
      case AppLifecycleState.resumed:
        // TODO: Handle this case.
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
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

    WidgetsBinding.instance!.addObserver(this);
    _log.info('Subscribed to app lifecycle updates');
  }
}
