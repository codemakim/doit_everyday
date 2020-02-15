import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';

class ProviderBannerAd with ChangeNotifier {
  final String adUnitId;
  BannerAd _bannerAd;
  MobileAdEvent _event;

  ProviderBannerAd({@required this.adUnitId});

  MobileAdEvent getEventResult() => _event;
  BannerAd getEventInfo() => this._bannerAd;

  void init() {
    this._bannerAd = BannerAd(
      adUnitId: this.adUnitId,
      size: AdSize.smartBanner,
      targetingInfo: MobileAdTargetingInfo(
        keywords: <String>['korean', 'game', 'programer'],
        contentUrl: 'https://flutter.io',
        childDirected: false,
        testDevices: <String>[], // Android emulators are considered test devices
      ),
      listener: (MobileAdEvent event) {
        print("#####");
        print("event result is $event");
        this._event = event;
        notifyListeners();
      }
    );
  }

  run() {
    this._bannerAd
        ..load()
        ..show(
          anchorOffset: 0.0,
          anchorType: AnchorType.bottom,
        );
  }

}