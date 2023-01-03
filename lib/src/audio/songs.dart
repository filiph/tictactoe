const Set<Song> songs = {
  // Filenames with whitespace break package:audioplayers on iOS
  // (as of February 2022), so we use no whitespace.
  Song('Mr_Smith-Azul.mp3', 'Azul', artist: 'Mr Smith'),
  Song('Mr_Smith-Sonorus.mp3', 'Sonorus', artist: 'Mr Smith'),
  Song('Mr_Smith-Sunday_Solitude.mp3', 'SundaySolitude', artist: 'Mr Smith'),
  Song('Mr_Smith-Black_Top.mp3', 'Black Top', artist: 'Mr Smith'),
  Song('Mr_Smith-Pequenas_Guitarras.mp3', 'Pequeñas Guitarras', artist: 'Mr Smith'),
  Song('Mr_Smith-Reflector.mp3', 'Reflector', artist: 'Mr Smith'),
  Song('Mr_Smith-The_Get_Away.mp3', 'The Get Away', artist: 'Mr Smith'),
  Song('Mr_Smith-The_Mariachi.mp3', 'The Mariachi', artist: 'Mr Smith'),
  Song('Mr_Smith-This_Could_Get_Dark.mp3', 'This Could Get Dark', artist: 'Mr Smith'),
};

class Song {
  final String filename;

  final String name;

  final String? artist;

  const Song(this.filename, this.name, {this.artist});

  @override
  String toString() => 'Song<$filename>';
}
