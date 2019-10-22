import 'package:flutter/material.dart';

class LayoutUtils {

  /// smartBanner의 사이즈를 구하기 위한 메소드입니다.
  double getBannerHeight(BuildContext context) {
    double result = 50.0;
    MediaQueryData mediaScrean = MediaQuery.of(context);
    double dpHeight = mediaScrean.orientation == Orientation.portrait
        ? mediaScrean.size.height
        : mediaScrean.size.width;
    if(dpHeight <= 400.0)
      result = 32.0;
    if(dpHeight > 720.0)
      result = 90.0;
    return result;
  }
}
