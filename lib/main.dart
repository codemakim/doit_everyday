import 'package:challenge_everyday/PrivateStrings.dart';
import 'package:challenge_everyday/provider/ProviderBannerAd.dart';
import 'package:challenge_everyday/repository/challengeRepository.dart';
import 'package:challenge_everyday/screen/mainPage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    statusBarBrightness: Brightness.light,
    statusBarColor: Colors.transparent,
  ));

  await MobileAds.instance.initialize();
  await ChallengeRepository().updateChallengeValid();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final String _appId = PrivateStrings.appId;
  final String _bannerId = PrivateStrings.bannerId;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProviderBannerAd>(
      create: (_) => ProviderBannerAd(adUnitId: _bannerId)
        ..init()
        ..run(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MainPage(),
      ),
    );
  }
}

Widget customContainer(BuildContext context) {
  //ProviderBannerAd pb = Provider.of<ProviderBannerAd>(context);
  return Container(
    height: 100,
  );
}
