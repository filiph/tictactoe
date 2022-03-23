import 'dart:collection';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart' hide Logger;
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';
import 'package:tictactoe/src/audio/songs.dart';

class AudioSystem extends ChangeNotifier {
  static final _log = Logger('AudioSystem');

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
  ///
  /// Background music does not count into the [polyphony] limit. Music will
  /// never be overridden by sound effects.
  AudioSystem({int polyphony = 2})
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

  @override
  void dispose() {
    stopAllSound();
    _musicPlayer.dispose();
    for (final player in _sfxPlayers) {
      player.dispose();
    }
    super.dispose();
  }

  void startMusic() {
    _log.info('starting music');
    _musicCache.play(_playlist.first.filename);
  }

  void resumeMusic() async {
    _log.info('Resuming music');
    switch (_musicPlayer.state) {
      case PlayerState.PAUSED:
        _log.info('Calling _musicPlayer.resume()');
        try {
          await _musicPlayer.resume();
        } catch (e) {
          // Sometimes, resuming fails with an "Unexpected" error.
          _log.severe(e);
          _musicCache.play(_playlist.first.filename);
        }
        break;
      case PlayerState.STOPPED:
        _log.info("resumeMusic() called when music is stopped. "
            "This probably means we haven't yet started the music. "
            "For example, the game was started with sound off.");
        _musicCache.play(_playlist.first.filename);
        break;
      case PlayerState.PLAYING:
        _log.warning('resumeMusic() called when music is playing. '
            'Nothing to do.');
        break;
      case PlayerState.COMPLETED:
        _log.warning('resumeMusic() called when music is completed. '
            "Music should never be 'completed' as it's either not playing "
            "or looping forever.");
        _musicCache.play(_playlist.first.filename);
        break;
    }
  }

  void stopAllSound() {
    if (_musicPlayer.state == PlayerState.PLAYING) {
      _musicPlayer.pause();
    }
    for (final player in _sfxPlayers) {
      player.stop();
    }
  }

  final Random _random = Random();

  void playSfx(SfxType type) {
    _log.info(() => 'Playing sound: $type');
    final options = _soundTypeToFilename(type);
    final filename = options[_random.nextInt(options.length)];
    _log.info(() => '- Chosen filename: $filename');
    _sfxCache.play(filename, volume: _soundTypeToVolume(type));
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
    _log.info(() => 'Playing ${_playlist.first} now.');
    _musicCache.play(_playlist.first.filename);
  }

  void stopMusic() {
    _log.info('Stopping music');
    if (_musicPlayer.state == PlayerState.PLAYING) {
      _musicPlayer.pause();
    }
  }
}

enum SfxType {
  drawX,
  drawO,
  buttonTap,
  congrats,
  erase,
  drawGrid,
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
      ];
    case SfxType.erase:
      return [
        'fwfwfwfwfw1.mp3',
        'fwfwfwfw1.mp3',
      ];
    case SfxType.drawGrid:
      return [
        'swishswish1.mp3',
      ];
  }
}

/// Allows control over loudness of different SFX types.
double _soundTypeToVolume(SfxType type) {
  switch (type) {
    case SfxType.drawX:
      return 0.4;
    case SfxType.drawO:
      return 0.2;
    case SfxType.buttonTap:
    case SfxType.congrats:
    case SfxType.erase:
    case SfxType.drawGrid:
      return 1.0;
  }
}
