import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';

class ProviderBannerAd with ChangeNotifier {
  final String adUnitId;
  BannerAd? _bannerAd;
  AdEvent? _event;

  ProviderBannerAd({required this.adUnitId});

  AdEvent? getEventResult() => _event;
  BannerAd? getEventInfo() => this._bannerAd;

  void init() {
    this._bannerAd = BannerAd(
      adUnitId: this.adUnitId,
      size: AdSize.banner,
      request: AdRequest(
        keywords: <String>['korean', 'game', 'programmer'],
        contentUrl: 'https://flutter.io',
      ),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print("#####");
          print("Ad loaded");
          this._event = AdEvent.loaded;
          notifyListeners();
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print("#####");
          print("Ad failed to load: $error");
          ad.dispose();
          this._event = AdEvent.failedToLoad;
          notifyListeners();
        },
        onAdOpened: (Ad ad) {
          print("#####");
          print("Ad opened");
          this._event = AdEvent.opened;
          notifyListeners();
        },
        onAdClosed: (Ad ad) {
          print("#####");
          print("Ad closed");
          this._event = AdEvent.closed;
          notifyListeners();
        },
      ),
    );
  }

  run() {
    this._bannerAd?.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }
}

enum AdEvent {
  loaded,
  failedToLoad,
  opened,
  closed,
}
