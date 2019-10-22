import 'package:flutter/cupertino.dart';

class FadeRoute extends PageRouteBuilder {
  final Widget page;

  FadeRoute({@required this.page})
      : super(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      }
  );
}
