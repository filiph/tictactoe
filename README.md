# flutter_game_sample

A sample project for a casual game built in Flutter.

## Demo

To make it easier for everyone to play with the sample, it's currently
[published here].

[published here]: https://filiph.github.io/flutter_game_sample/mobile.html.

## Building

Right now, we're using `pkg:rough` which is not null safe. So, in order
to build for the web, we need to do all this:

    fvm flutter pub global run peanut --extra-args "--no-sound-null-safety"
