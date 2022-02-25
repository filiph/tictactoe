# flutter_game_sample

A sample mobile game built in Flutter.

## Demo

To make it easier for everyone to play with the sample, it's currently
[published here].

[published here]: https://filiph.github.io/flutter_game_sample/mobile.html.

## Building

To build and publish to github.io:

    fvm flutter pub global run peanut \
    --extra-args "--dart-define flavor=lite" \
    --base-href "/flutter_game_sample/" \
    && git push origin --set-upstream gh-pages
