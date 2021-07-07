import 'package:flutter/material.dart';
import 'package:edutech/constants/app_assets.dart';

class AppLogoWidget extends StatelessWidget {
  final double radius;
  final double elevation;
  final double height;
  final double width;

  

  const AppLogoWidget({Key key, this.radius = 4, this.elevation = 1, this.height = 90, this.width = 90, })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.antiAlias,
      elevation: elevation,
      borderRadius: BorderRadius.circular(radius),
      child: Image.asset(
        kIcLogo,
        width: width,
        height: height,

      ),
    );
  }
}
