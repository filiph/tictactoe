import 'dart:io';

import 'package:flutter/foundation.dart';

/// This compile-time constant will be set according to Dart's compile-time
/// environment variable named 'flavor'.
///
/// To get this to be [Flavor.full], run the app with:
///
///     flutter run --dart-define=flavor=full
///
/// To get this to be [Flavor.lite], run the app with:
///
///     flutter run --dart-define=flavor=lite
///
/// If you don't define the flag at all, [flavor] will be [Flavor.undefined].
/// The app should refuse to execute (throw an error at startup). That way,
/// there's no way to forget to specify a flavor (a common source of confusion
/// when debugging).
const Flavor flavor = _flavorFlag == 'full'
    ? Flavor.full
    : _flavorFlag == 'lite'
        ? Flavor.lite
        : Flavor.undefined;

/// This constant is populated from something like
/// `flutter run --dart-define=flavor=x`.
const String _flavorFlag = String.fromEnvironment('flavor');

/// Returns `true` if the platform supports ads.
///
/// Checks first that `kIsWeb` is not true, because [Platform] is not
/// supported on the web.
final platformSupportsAds = !kIsWeb && (Platform.isIOS || Platform.isAndroid);

/// Returns `true` if the platform supports game services (Games Center,
/// Google Play Games).
final platformSupportsGameServices =
    !kIsWeb && (Platform.isIOS || Platform.isAndroid);

/// Returns `true` if the platform supports in-app purchases.
final platformSupportsInAppPurchases = platformSupportsAds;

/// Checks if [flavor] is defined.
///
/// In Debug mode, throws an error if it isn't.
bool checkFlavorDefined() {
  if (flavor == Flavor.undefined) {
    if (kDebugMode) {
      // Fail fast.
      throw ArgumentError(
          'No flavor environment variable defined. Please provide a value when '
          'running `flutter build` or `flutter run`. For example, if you '
          'want to debug the full app, run '
          '`flutter run --dart-define=flavor=full`.');
    }

    return false;
  }
  return true;
}

enum Flavor {
  undefined,
  full,
  lite,
}
