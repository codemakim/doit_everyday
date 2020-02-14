import 'package:challenge_everyday/privateStrings.dart';
import 'package:challenge_everyday/repository/challengeRepository.dart';
import 'package:challenge_everyday/screen/mainPage.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    statusBarBrightness: Brightness.light,
    statusBarColor: Colors.transparent,
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final String _appId = PrivateStrings.appId;
  final String _bannerId = PrivateStrings.bannerId;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    FirebaseAdMob.instance.initialize(appId: _appId);

    /**
     * 배너 광고를 위한 fireBase_adMobs 초기화
     */
    MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
      keywords: <String>['korean', 'game', 'programer'],
      contentUrl: 'https://flutter.io',
      childDirected: false,
      testDevices: <String>[], // Android emulators are considered test devices
    );

    BannerAd myBanner = BannerAd(
      /// 테스트 광고 설정
      //adUnitId: BannerAd.testAdUnitId,
      adUnitId: _bannerId,
      targetingInfo: targetingInfo,
      size: AdSize.smartBanner,
      listener: (MobileAdEvent event) {
        print('########################################');
        print("BannerAd event is $event");
      },
    );
    //fireBase_adMobs 초기화 끝

    myBanner
      ..load()
      ..show(
        anchorOffset: 0.0,
        anchorType: AnchorType.bottom,
      );

    void printBannerAd() async {
      var result = await myBanner.isLoaded();
      print('myBanner.isLoaded() : $result');
    }

    printBannerAd();

    ChallengeRepository().updateChallengeValid();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Column(
        children: <Widget>[
          Expanded(
            child: MainPage(),
          ),
          FutureBuilder<bool>(
            future: myBanner.show(),
            builder: (context, snapshot) {
              return Container(
                height: (snapshot.hasData && snapshot.data) ? myBanner.size.height.toDouble() : 0,
              );
            }
          )
        ],
      ),


    );
  }
}
