import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logging/logging.dart';

class PreloadedBannerAd {
  static final _log = Logger('PreloadedBannerAd');

  /// Something like [AdSize.mediumRectangle].
  final AdSize size;

  final AdRequest _adRequest;

  BannerAd? _bannerAd;

  final _adCompleter = Completer<BannerAd>();

  PreloadedBannerAd({
    required this.size,
    AdRequest? adRequest,
  }) : _adRequest = adRequest ?? AdRequest();

  Future<BannerAd> get ready => _adCompleter.future;

  Future<void> load(BuildContext context) {
    assert(Platform.isAndroid || Platform.isIOS,
        'AdMob currently does not support ${Platform.operatingSystem}');

    _bannerAd = BannerAd(
      // This is a test ad unit ID from
      // https://developers.google.com/admob/android/test-ads. When ready,
      // you replace this with your own, production ad unit ID,
      // created in https://apps.admob.com/.
      adUnitId: Theme.of(context).platform == TargetPlatform.android
          ? 'ca-app-pub-3940256099942544/6300978111'
          : 'ca-app-pub-3940256099942544/2934735716',
      size: size,
      request: _adRequest,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          _log.info(() => 'Ad loaded: ${_bannerAd.hashCode}');
          _adCompleter.complete(_bannerAd);
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          _log.warning('Banner failedToLoad: $error');
          _adCompleter.completeError(error);
          ad.dispose();
        },
        onAdImpression: (Ad ad) {
          _log.info('Ad impression registered');
        },
        onAdClicked: (Ad ad) {
          _log.info('Ad click registered');
        },
      ),
    );

    return _bannerAd!.load();
  }

  // void dispose() {
  //   _log.info('preloaded banner ad being desposed');
  //   _bannerAd?.dispose();
  // }
}
