import 'package:floor_bot_mobile/app/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: SvgPicture.asset(
          Utils.appLogo,
          // Let the asset render normally; if the app is in dark mode and
          // the SVG is a single-color asset you can override its color
          // elsewhere. Using theme background ensures buttons and other
          // widgets keep their intended contrast in dark mode.
        ),
      ),
    );
  }
}
