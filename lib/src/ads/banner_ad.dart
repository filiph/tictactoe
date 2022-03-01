import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logging/logging.dart';

/// Displays a banner ad that conforms to the widget's size in the layout,
/// and reloads the ad when the user changes orientation.
///
/// Do not use this widget on platforms that AdMob currently doesn't support.
/// For example:
///
/// ```dart
/// if (kIsWeb) {
///   return Text('No ads here! (Yet.)');
/// } else {
///   return MyBannerAd();
/// }
/// ```
///
/// This widget is adapted from pkg:google_mobile_ads's example code,
/// namely the `anchored_adaptive_example.dart` file:
/// https://github.com/googleads/googleads-mobile-flutter/blob/main/packages/google_mobile_ads/example/lib/anchored_adaptive_example.dart
class MyBannerAd extends StatefulWidget {
  const MyBannerAd({Key? key}) : super(key: key);

  @override
  _MyBannerAdState createState() => _MyBannerAdState();
}

class _MyBannerAdState extends State<MyBannerAd> {
  static final _log = Logger('MyBannerAd');

  BannerAd? _bannerAd;
  bool _isLoaded = false;
  late Orientation _currentOrientation;

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (_currentOrientation == orientation &&
            _bannerAd != null &&
            _isLoaded) {
          _log.info('We have everything we need. Showing the banner now.');
          return SizedBox(
            width: _bannerAd!.size.width.toDouble(),
            height: _bannerAd!.size.height.toDouble(),
            child: AdWidget(ad: _bannerAd!),
          );
        }
        // Reload the ad if the orientation changes.
        if (_currentOrientation != orientation) {
          _log.info('Orientation changed');
          _currentOrientation = orientation;
          _loadAd();
        }
        return SizedBox();
      },
    );
  }

  @override
  void didChangeDependencies() {
    _log.fine('didChangeDependencies');
    super.didChangeDependencies();
    _currentOrientation = MediaQuery.of(context).orientation;
    _loadAd();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  /// Load (another) ad, disposing of the current ad if there is one.
  Future<void> _loadAd() async {
    _log.info('_loadAd() called. Disposing of _bannerAd now.');
    await _bannerAd?.dispose();
    _log.fine('_bannerAd disposed');
    setState(() {
      _bannerAd = null;
      _isLoaded = false;
    });

    final AnchoredAdaptiveBannerAdSize? size =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
            MediaQuery.of(context).size.width.truncate());

    if (size == null) {
      _log.warning('Unable to get height of anchored banner.');
      return;
    }

    assert(Platform.isAndroid || Platform.isIOS,
        'AdMob currently does not support ${Platform.operatingSystem}');
    _bannerAd = BannerAd(
      // This is a test ad unit ID from
      // https://developers.google.com/admob/android/test-ads. When ready,
      // you replace this with your own, production ad unit ID,
      // created in https://apps.admob.com/.
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/6300978111'
          : 'ca-app-pub-3940256099942544/2934735716',
      size: size,
      request: AdRequest(),
      listener: BannerAdListener(onAdLoaded: (Ad ad) {
        _log.info('Ad loaded: ${ad.responseInfo}');
        setState(() {
          // When the ad is loaded, get the ad size and use it to set
          // the height of the ad container.
          _bannerAd = ad as BannerAd;
          _isLoaded = true;
        });
      }, onAdFailedToLoad: (Ad ad, LoadAdError error) {
        _log.warning('Banner failedToLoad: $error');
        ad.dispose();
      }, onAdImpression: (Ad ad) {
        _log.info('Add impression registered');
      }, onAdClicked: (Ad ad) {
        _log.info('Add click registered');
      }),
    );
    return _bannerAd!.load();
  }
}
