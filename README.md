# tictactoe

A sample mobile game built in Flutter.

## Demo

To make it easier for everyone to play with the sample, it's currently
[published here][].

[published here]: https://filiph.github.io/flutter_game_sample/mobile.html.

## Development

Code is organized in a loose and shallow feature-first fashion.
In `lib/src`, you'll therefore find directories such as `ads`, `ai`, `audio`
or `main_menu`. Nothing fancy, but usable.

### Flavors

We don't need [Android- or iOS-level flavors][] (yet?) but we do need at least two
Flutter-level flavors. This means that while the code in `/android` and `/ios`
stays the same, the compiled Dart code will differ.

[Android- or iOS-level flavors]: https://docs.flutter.dev/deployment/flavors

In particular, we need a 'lite' version of the game and a 'full' version.
The lite version is primarily used for the web demo, and doesn't include ads
and some of the content. But nothing stops us from creating another flavor
for, say, premium versions of the game.

Flavor is defined using environment variables. This approach is
[described here](https://itnext.io/flutter-1-17-no-more-flavors-no-more-ios-schemas-command-argument-that-solves-everything-8b145ed4285d),
for example.

### Building

The following assumes using [FVM][]. Just remove `fvm` from the commands if you
don't use FVM for Flutter version management.

[FVM]: https://fvm.app/

To build and publish to github.io:

    fvm flutter pub global run peanut \
    --web-renderer canvaskit \
    --extra-args "--dart-define flavor=lite --base-href=/flutter_game_sample/" \
    && git push origin --set-upstream gh-pages

To build the app for iOS:

    fvm flutter build ipa --dart-define flavor=full && open build/ios/archive/Runner.xcarchive

To build the app for Android:

    fvm flutter build appbundle --dart-define flavor=full && open build/app/outputs/bundle/release
