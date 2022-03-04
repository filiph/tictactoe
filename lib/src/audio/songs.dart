const Set<Song> songs = {
  // Filenames with whitespace break package:audioplayers on iOS
  // (as of February 2022), so we use no whitespace.
  Song('Mr_Smith-Azul.mp3', 'Azul'),
  Song('Mr_Smith-Black_Top.mp3', 'Black Top'),
  Song('Mr_Smith-Pequenas_Guitarras.mp3', 'Pequeñas Guitarras'),
  Song('Mr_Smith-Reflector.mp3', 'Reflector'),
  Song('Mr_Smith-Sonorus.mp3', 'Sonorus'),
  Song('Mr_Smith-Sunday_Solitude.mp3', 'SundaySolitude'),
  Song('Mr_Smith-The_Get_Away.mp3', 'The Get Away'),
  Song('Mr_Smith-The_Mariachi.mp3', 'The Mariachi'),
  Song('Mr_Smith-This_Could_Get_Dark.mp3', 'This Could Get Dark'),
};

class Song {
  final String filename;

  final String author = 'Mr Smith';

  final String name;

  const Song(this.filename, this.name);

  @override
  String toString() => 'Song<$filename>';
}
