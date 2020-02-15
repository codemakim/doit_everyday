import 'package:flutter/material.dart';

class HeightBannerUtil {

  /// smartBanner 의 사이즈를 구하기 위한 메소드입니다.
  double getBannerHeight(BuildContext context) {
    double result = 50.0;
    MediaQueryData mediaScreen = MediaQuery.of(context);
    double dpHeight = mediaScreen.orientation == Orientation.portrait
        ? mediaScreen.size.height
        : mediaScreen.size.width;
    if(dpHeight <= 400.0)
      result = 32.0;
    if(dpHeight > 720.0)
      result = 90.0;
    return result;
  }
}
