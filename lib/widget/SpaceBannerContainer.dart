import 'package:challenge_everyday/provider/ProviderBannerAd.dart';
import 'package:challenge_everyday/utils/HeightBannerUtil.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SpaceBannerContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ProviderBannerAd pb = Provider.of<ProviderBannerAd>(context);
    return Container(
      height: (pb.getEventResult() == MobileAdEvent.loaded) ?
        HeightBannerUtil().getBannerHeight(context) : 0,
    );
  }
}
