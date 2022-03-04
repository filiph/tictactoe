import 'dart:collection';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart' hide Logger;
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/src/audio/songs.dart';

class AudioSystem extends ChangeNotifier {
  static final _log = Logger('AudioSystem');

  bool _isOn = false;

  late AudioCache _musicCache;

  late AudioCache _sfxCache;

  final AudioPlayer _musicPlayer;

  /// This is a list of [AudioPlayer] instances which are rotated to play
  /// sound effects.
  ///
  /// Normally, we would just call [AudioCache.play] and let it procure its
  /// own [AudioPlayer] every time. But this seems to lead to errors and
  /// bad performance on iOS devices.
  final List<AudioPlayer> _sfxPlayers;

  int _currentSfxPlayer = 0;

  final Queue<Song> _playlist;

  /// Creates an instance that plays music and sound.
  ///
  /// Use [polyphony] to configure the number of sound effects (SFX) that can
  /// play at the same time. A [polyphony] of `1` will always only play one
  /// sound (a new sound will stop the previous one). See discussion
  /// of [_sfxPlayers] to learn why this is the case.
  AudioSystem({int polyphony = 3})
      : assert(polyphony >= 1),
        _musicPlayer = AudioPlayer(playerId: 'musicPlayer'),
        _sfxPlayers = Iterable.generate(
            polyphony,
            (i) => AudioPlayer(
                playerId: 'sfxPlayer#$i',
                mode: PlayerMode.LOW_LATENCY)).toList(growable: false),
        _playlist = Queue.from(List.of(songs)..shuffle()) {
    _musicCache = AudioCache(
      fixedPlayer: _musicPlayer,
      prefix: 'assets/music/',
    );
    _sfxCache = AudioCache(
      fixedPlayer: _sfxPlayers.first,
      prefix: 'assets/sfx/',
    );

    _musicPlayer.onPlayerCompletion.listen(_changeSong);
  }

  bool get isOn => _isOn;

  set isOn(bool value) {
    if (value == _isOn) return;
    _isOn = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _musicPlayer.dispose();
    for (final player in _sfxPlayers) {
      player.dispose();
    }
    super.dispose();
  }

  void resumeAfterAppPaused() {
    if (_isOn) {
      resumeMusic();
    }
  }

  void startMusic() {
    _log.info('starting music');
    _musicCache.play(_playlist.first.filename);
  }

  void resumeMusic() {
    _musicPlayer.resume();
  }

  void stopForAppPaused() {
    mute();
  }

  void mute() {
    _musicPlayer.pause();
    for (final player in _sfxPlayers) {
      player.stop();
    }
  }

  final Random _random = Random();

  void playSfx(SfxType type) {
    _log.info('Playing sound: $type');
    final options = _soundTypeToFilename(type);
    final filename = options[_random.nextInt(options.length)];
    _log.info('- Chosen filename: $filename');
    _sfxCache.play(filename);
    _currentSfxPlayer = (_currentSfxPlayer + 1) % _sfxPlayers.length;
    _sfxCache.fixedPlayer = _sfxPlayers[_currentSfxPlayer];
  }

  void initialize() async {
    _log.info('Preloading sound effects');
    await _sfxCache
        .loadAll(SfxType.values.expand(_soundTypeToFilename).toList());
  }

  void _changeSong(void _) {
    _log.info('Last song finished playing.');
    // Put the song that just finished playing to the end of the playlist.
    _playlist.addLast(_playlist.removeFirst());
    // Play the next song.
    _log.info('Playing ${_playlist.first} now.');
    _musicCache.play(_playlist.first.filename);
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
    _audioSystem = AudioSystem();
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
