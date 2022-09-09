# TripleT Game
#

## Demo

To make it easier for everyone to play with the sample, it's currently
published as a web demo.



## Development

To run the app in debug mode:

    flutter run

### Code organization

Code is organized in a loose and shallow feature-first fashion.
In `lib/src`, you'll therefore find directories such as `ads`, `ai`, `audio`
or `main_menu`. Nothing fancy, but usable.

The state management approach is intentionally low-level. That way, it's easy to
take this project and run with it, without having to learn new paradigms, or having
to remember to run `flutter pub run build_runner watch`. You are,
of course, encouraged to use whatever paradigm, helper package or code generation
scheme to build on top of this project.


### Building for production

The following assumes using [FVM][]. Just remove `fvm` from the commands if you
don't use FVM for Flutter version management.

[FVM]: https://fvm.app/

To build and publish to github.io:

    fvm flutter pub global run peanut \
    --web-renderer canvaskit \
    --extra-args "--base-href=/tictactoe/" \
    && git push origin --set-upstream gh-pages

To build the app for iOS (and open Xcode when finished):

    fvm flutter build ipa --bundle-sksl-path warmup_2022-05-12_ios.sksl.json && open build/ios/archive/Runner.xcarchive

To build the app for Android (and open the folder with the bundle when finished):

    fvm flutter build appbundle --bundle-sksl-path warmup_2022-05-12_android_pixel5.sksl.json && open build/app/outputs/bundle/release

#### SkSL shaders

To update the `warmup_2022-04-27_xxx.sksl.json` files used in the commands above,
use the official [SkSL shader warmup guide][].

[SkSL shader warmup guide]: https://docs.flutter.dev/perf/shader#how-to-use-sksl-warmup

The game, despite being simple, uses shaders all over the place for the "drawing ink"
effect. In my testing, the performance is fine on most reasonable devices,
but why not make it even better?

Note: You can remove the `--bundle-sksl-path warmup_xxx.json` part
of the commands above if you're in a place where you care more about
development speed than performance. For example, when you need a quick
turnaround for some testing and can't be bothered to manually 
re-capture the shaders.


### Icon

Updating the launcher icon:

    fvm flutter pub run flutter_launcher_icons:main
