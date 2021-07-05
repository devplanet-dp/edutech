import 'package:flutter/material.dart';
import 'package:edutech/constants/app_assets.dart';

class AppLogoWidget extends StatelessWidget {
  final double radius;
  final double elevation;
  

  const AppLogoWidget({Key key, this.radius = 4, this.elevation = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.antiAlias,
      elevation: elevation,
      borderRadius: BorderRadius.circular(radius),
      child: Image.asset(
        kIcLogo,
        width: 72,
        height: 72,
      ),
    );
  }
}
