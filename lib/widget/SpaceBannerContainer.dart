import 'package:challenge_everyday/provider/ProviderBannerAd.dart';
import 'package:challenge_everyday/utils/HeightBannerUtil.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SpaceBannerContainer extends StatelessWidget {
  const SpaceBannerContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProviderBannerAd pb = Provider.of<ProviderBannerAd>(context);
    return Container(
      height: (pb.getEventResult() == AdEvent.loaded)
          ? HeightBannerUtil().getBannerHeight(context)
          : 0,
    );
  }
}
